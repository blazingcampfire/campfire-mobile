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
        
        var body: some View {
                Form {
                    Section(header: Text("Display")) {
                        Toggle(isOn: .constant(false)) {
                            Label {
                                Text("Dark Mode")
                            } icon: {
                                Image(systemName: "moon")
                                    .foregroundColor(Theme.Peach)
                            }
                        }
                        .font(.custom("LexendDeca-Regular", size: 16))
                        
                        Toggle(isOn: .constant(true)) {
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
                        //  Label("Report Account", systemImage: "exclamationmark.triangle.fill")
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
                        NavigationLink(destination: AccountSetUp()) {
                            Label {
                                Text("Log Out")
                            } icon: {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Theme.Peach)
                            }
                        }
                        Label {
                            Text("Delete Account")
                        } icon: {
                            Image(systemName: "delete.right")
                                .foregroundColor(Theme.Peach)
                        }
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
