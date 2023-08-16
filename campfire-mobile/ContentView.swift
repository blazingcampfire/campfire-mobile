//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @StateObject var authModel: AuthModel = AuthModel()
    @StateObject var currentUser: CurrentUserModel = emptyCurrentUser
    @StateObject var notificationsManager = NotificationsManager()
   
    
    var body: some View {
        if currentUser.signedIn && (!authModel.createAccount && !authModel.login) {
            NavigationBar()
                .onAppear {
                    currentUser.setCollectionRefs()
                    currentUser.getUser()
                    currentUser.getProfile()
                }
                .environmentObject(currentUser)
                .environmentObject(notificationsManager)
        }
        else {
            AccountSetUp()
                .environmentObject(authModel)
                .environmentObject(currentUser)
                .environmentObject(notificationsManager)
        }
        
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchScreen()
        }
    }
}
