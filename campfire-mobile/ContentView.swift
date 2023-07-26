//
//  ContentView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI
import CoreData
import SwiftUICam

struct ContentView: View {
    @StateObject var model = authModel()
    @ObservedObject var events = UserEvents()
    
    var body: some View {
        LaunchScreen()
            .environmentObject(model)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
                .environmentObject(authModel())
            }
        }
    



