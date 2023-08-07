//
//  SettingsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        NavigationView {
            SettingsForm()
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
    @StateObject var model: SettingsModel = SettingsModel()
    @State var darkMode: Bool = false
    @State var notifications: Bool = false
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

                Toggle(isOn: $notifications) {
                    Label {
                        Text("Notifications")
                    } icon: {
                        Image(systemName: "bell.fill")
                            .foregroundColor(Theme.Peach)
                    }
                }
            }

            .font(.custom("LexendDeca-Regular", size: 16))
            Section(header: Text("About")) {
                Label {
                    Text("FAQ")
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
                            print("Signed Out")
                            model.signedOut = true
                        } catch {
                            print(error)
                        }
                    }, label: {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Theme.Peach)
                            Text("Log Out")
                                .foregroundColor(Theme.TextColor)
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
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
