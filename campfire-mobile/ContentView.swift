//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import FirebaseAuth
import SwiftUI
import Combine
import FirebaseMessaging

struct ContentView: View {
    @StateObject var authModel: AuthModel = AuthModel()
    @StateObject var currentUser: CurrentUserModel = emptyCurrentUser
    @StateObject var notificationsManager = NotificationsManager()
    
    var body: some View {
        if currentUser.signedIn && (!authModel.createAccount && !authModel.login) {
InitialMessage(school: "yo")
            //            NavigationBar()
//                .onAppear {
//                    currentUser.setCollectionRefs()
//                    currentUser.getUser()
//                    currentUser.getProfile()
//                    Task {
//                        await notificationsManager.getAuthStatus()
//                        await notificationsManager.request()
//                        await notificationsManager.sendNotification(title: "Test", subtitle: "String")
//                        notificationsManager.getToken()
//                    }
//                }
//                .environmentObject(currentUser)
//                .environmentObject(notificationsManager)
//                .environmentObject(authModel)
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
