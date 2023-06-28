//
//  SettingsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

struct SettingsPage: View {
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            NavigationView {
                //accents peach color for icon
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
                            Image(systemName: "doc.fill")
                                .foregroundColor(Theme.Peach)
                        }
                        
                        Text("Privacy Policy")
                        Text("Terms of Service")
                    }
                    .font(.custom("LexendDeca-Regular", size: 16))
                    
                    
                    Section(header: Text("Support")) {
                        //  Label("Report Account", systemImage: "exclamationmark.triangle.fill")
                        Label {
                            Text("Report Account")
                        } icon: {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Theme.Peach)
                        }
                        
                        
                        Text("Contact Us")
                    }
                    .font(.custom("LexendDeca-Regular", size: 16))
                    
                    Section(header: Text("Account Permissions")) {
                        Text("Log Out")
                        Text("Delete Account")
                    }
                    .font(.custom("LexendDeca-Regular", size: 16))
                    
                }
                .navigationTitle("Settings").font(.custom("LexendDeca-Regular", size: 25))
            }
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
