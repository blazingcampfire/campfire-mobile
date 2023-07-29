//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI
import CoreData
import FirebaseAuth

struct ContentView: View {
    @StateObject var model = AuthModel()
    var body: some View {
        if Auth.auth().currentUser?.email == nil {
            AccountSetUp()
                .environmentObject(model)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        else {
            NavigationBar()
        }

    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchScreen()
                .environmentObject(AuthModel())
        }
    }
}
    


