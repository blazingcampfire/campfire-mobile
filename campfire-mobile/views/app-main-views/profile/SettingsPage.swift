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
                            Text("Settings")
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
    @State var notifications: Bool = false
    @EnvironmentObject var model: SettingsModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    var body: some View {
        Form {
            Section(header: Text("Display")) {
                Toggle(isOn: $darkMode) {
                    Label {
                        Text("Dark Mode")
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
                        Text("Turn Notifications On/Off")
                            .foregroundColor(Theme.TextColor)
                    } icon: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Theme.Peach)
                    }
                })
            }

            .font(.custom("LexendDeca-Regular", size: 16))
            Section(header: Text("About")) {
                Label {
                    Text("Community Guidelines")
                } icon: {
                    Image(systemName: "doc.plaintext.fill")
                        .foregroundColor(Theme.Peach)
                }
                Label {
                    Text("Privacy Policy")
                } icon: {
                    Image(systemName: "key")
                        .foregroundColor(Theme.Peach)
                }
                Label {
                    Text("Terms of Service")
                } icon: {
                    Image(systemName: "doc.plaintext.fill")
                        .foregroundColor(Theme.Peach)
                }
            }
            .font(.custom("LexendDeca-Regular", size: 16))

            Section(header: Text("Support")) {
                Label {
                    Text("Report Issue")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(Theme.Peach)
                }
                Label {
                    Text("Contact Us")
                } icon: {
                    Image(systemName: "envelope")
                        .foregroundStyle(Theme.Peach)
                }
            }
            .font(.custom("LexendDeca-Regular", size: 16))

            Section(header: Text("Account")) {
                VStack {
                    Button(action: {
                        do {
                            try model.signOut()
                        } catch {
                            print(error)
                        }
                    }, label: {
                        Label {
                            Text("Log Out")
                                .foregroundColor(Theme.TextColor)
                        } icon: {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Theme.Peach)
                        }
                    })
                }
                //                        NavigationLink(destination: AccountSetUp()) {
                //                            Label {
                //                                Text("Log Out")
                //                            } icon: {
                //                                Image(systemName: "lock.fill")
                //                                    .foregroundColor(Theme.Peach)
                //                            }
                //                        }
                //                        Label {
                //                            Text("Delete Account")
                //                        } icon: {
                //                            Image(systemName: "delete.right")
                //                                .foregroundColor(Theme.Peach)
                //                        }
            }
            .font(.custom("LexendDeca-Regular", size: 16))
        }
        .preferredColorScheme(darkMode ? .dark : .light)
    }
}

//struct SettingsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsPage()
//    }
//}
