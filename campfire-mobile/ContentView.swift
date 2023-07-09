//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var user = newUser()
    
    var body: some View {
        AccountSetUp()
            .environmentObject(user)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            AccountSetUp()
                .environmentObject(newUser())
        }
    }
}
