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
                
                Form {
                    Section(header: Text("Display")) {
                        
                            Toggle(isOn: .constant(false)) {
                                Label("Dark Mode", systemImage: "moon")
                            }
                            
                            Toggle(isOn: .constant(true)) {
                                Label("Notifications", systemImage: "bell.fill")
                            }
                        }
                        
                        .font(.custom("LexendDeca", size: 16))
                        Section(header: Text("About")) {
                            Label("FAQ", systemImage: "doc.fill")
                            Text("Privacy Policy")
                            Text("Terms of Service")
                        }
                        .font(.custom("LexendDeca", size: 16))
                    
                
                    Section(header: Text("Support")) {
                        Label("Report Account", systemImage: "exclamationmark.triangle.fill")
                        Text("Contact Us")
                    }
                    .font(.custom("LexendDeca", size: 16))
                    
                    Section(header: Text("Account Permissions")) {
                        Text("Log Out")
                        Text("Delete Account")
                    }
                    .font(.custom("LexendDeca", size: 16))
                    
                }
                .navigationTitle("Settings").font(.custom("LexendDeca", size: 25))
            }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage()
    }
}
