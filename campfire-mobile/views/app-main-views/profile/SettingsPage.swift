//
//  SettingsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

struct SettingsPage: View {
    @Binding var darkMode: Bool
    @StateObject var model: SettingsModel
    var body: some View {
        NavigationView {
            SettingsForm(darkMode: $darkMode)
                .environmentObject(model)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text("settings")
                                .font(.custom("LexendDeca-SemiBold", size: 30))
                                .foregroundColor(Theme.TextColor)
                        }
                    }
                }
        }
    }
}

struct SettingsForm: View {
    @Binding var darkMode: Bool
    @State var showDeleteAlert: Bool = false
    @EnvironmentObject var model: SettingsModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    @Environment(\.openURL) var openURL
    @State var emailAlert: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("display")) {
                Toggle(isOn: $darkMode) {
                    Label {
                        Text("dark mode")
                    } icon: {
                        Image(systemName: "moon")
                            .foregroundColor(Theme.Peach)
                    }
                }
                .font(.custom("LexendDeca-Regular", size: 16))
                
                Button(action: {
                    Task {
                        await model.notificationsManager.turnOffNotifications()
                    }
                }, label: {
                    Label {
                        Text("turn notifications on/off")
                            .foregroundColor(Theme.TextColor)
                    } icon: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Theme.Peach)
                    }
                })
            }
            
            .font(.custom("LexendDeca-Regular", size: 16))
            Section(header: Text("about")) {
                Link(destination: URL(string: "https://www.campfireco.app/community-guidelines")!) {
                    Label {
                        Text("community guidelines")
                    } icon: {
                        Image(systemName: "doc.plaintext.fill")
                            .foregroundColor(Theme.Peach)
                    }
                }
                Link(destination: URL(string: "https://burnt-sternum-fd5.notion.site/Privacy-Policy-3b8b7d05e438423daf0040181f2d98cf")!) {
                    Label {
                        Text("privacy policy")
                    } icon: {
                        Image(systemName: "key")
                            .foregroundColor(Theme.Peach)
                    }
                }
                Link(destination: URL(string: "https://burnt-sternum-fd5.notion.site/Terms-of-Service-4b592b52c33e44f29b0669d55a236e9e")!) {
                    Label {
                        Text("terms of service")
                    } icon: {
                        Image(systemName: "doc.plaintext.fill")
                            .foregroundColor(Theme.Peach)
                    }
                }
            }
            .font(.custom("LexendDeca-Regular", size: 16))
            .foregroundColor(Theme.TextColor)
            
            Section(header: Text("support")) {
                Link(destination: URL(string: "mailto:adarsh@gmail.com")!) {
                    Label {
                        Text("report issue")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(Theme.Peach)
                    }
                }
                Button {
                    mailto("adt@gmail.com")
                } label: {
                    
                    NavigationLink(destination: EmailView()) {
                        Label {
                            Text("contact us")
                        } icon: {
                            Image(systemName: "envelope")
                                .foregroundStyle(Theme.Peach)
                        }
                    }
                }
                .font(.custom("LexendDeca-Regular", size: 16))
                
                Section(header: Text("account")) {
                    VStack {
                        Button(action: {
                            do {
                                try model.signOut()
                            } catch {
                                print(error)
                            }
                        }, label: {
                            Label {
                                Text("log out")
                                    .foregroundColor(Theme.TextColor)
                            } icon: {
                                Image(systemName: "lock")
                                    .foregroundColor(Theme.Peach)
                            }
                        })
                    }
                    VStack {
                        Button(action: {
                            showDeleteAlert = true
                        }, label: {
                            Label {
                                Text("delete account")
                                    .foregroundColor(Theme.TextColor)
                            } icon: {
                                Image(systemName: "delete.left.fill")
                                    .foregroundColor(Theme.Peach)
                            }
                        })
                    }
                }
                .alert(title: "Are You Sure You Want to Delete Your Account?", message: "WARNING: THIS ACTION CANNOT BE UNDONE (it's serious enough to make us use CAPS, and we never use CAPS...)",
                       dismissButton: CustomAlertButton(title: "yes", action: {
                    do {
                        try model.deleteAccount()
                    } catch {
                        model.deleteErrorAlert = true
                    }
                }),
                       isPresented: $showDeleteAlert)
                .alert(title: "There Was An Error Deleting Your Account", message: "Please try again.",
                       dismissButton: CustomAlertButton(title: "ok", action: { }),
                       isPresented: $model.deleteErrorAlert)
                .font(.custom("LexendDeca-Regular", size: 16))
            }
        }
    }
    func mailto(_ email: String) {
        let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailto = "mailto:\(encodedEmail)"
        print(mailto)
        if let url = URL(string: mailto) {
            openURL(url)
        }
    }
}

// struct SettingsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPage()
//    }
// }
