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
    @StateObject var currentUser: CurrentUserModel = CurrentUserModel(privateUserData: PrivateUser(phoneNumber: "", email: "", userID: "", school: ""), profile: Profile(name: "", nameInsensitive: "", phoneNumber: "", email: "", username: "", posts: [], smores: 0, profilePicURL: "", userID: "", school: "", bio: ""), userRef: ndUsers, profileRef: ndProfiles, relationshipsRef: ndRelationships, postsRef: ndPosts)
    var body: some View {
        AccountSetUp()
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .environmentObject(authModel)
            .environmentObject(currentUser)
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchScreen()
        }
    }
}
