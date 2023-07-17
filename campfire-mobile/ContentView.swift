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
    @StateObject var model = authModel()
    var body: some View {
        if Auth.auth().currentUser?.uid != nil {
            AccountSetUp()
                .environmentObject(model)
        }
        else {
            LaunchScreen()
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LaunchScreen()
                .environmentObject(authModel())
        }
    }
}
