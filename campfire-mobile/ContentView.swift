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
    var body: some View {
        if currentUser.signedIn && !authModel.createAccount {
            NavigationBar()
                .onAppear {
                    currentUser.setCollectionRefs()
                    currentUser.getUser()
                    currentUser.getProfile()
                }
                .environmentObject(currentUser)
        }
        else {
            AccountSetUp()
                .environmentObject(authModel)
                .environmentObject(currentUser)
        }
        
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchScreen()
        }
    }
}
