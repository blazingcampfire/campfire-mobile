//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var model = CurrentUserModel(privateUserData: PrivateUser(phoneNumber: "", email: "", userID: "", school: ""), profile: Profile(name: "", nameInsensitive: "", phoneNumber: "", email: "", username: "", posts: [], smores: 0, profilePicURL: "", userID: "", school: "", bio: ""))
    
    var body: some View {
        if Auth.auth().currentUser?.email == nil || !model.isMainAppPresented {
                    AccountSetUp()
                        .environmentObject(model)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                else {
                    NavigationBar()
                        .environmentObject(model)
                }
        
            }
        
            struct ContentView_Previews: PreviewProvider {
                static var previews: some View {
                    LaunchScreen()
                }
            }
    }

    


