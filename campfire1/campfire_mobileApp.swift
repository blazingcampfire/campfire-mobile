//
//  campfire_mobileApp.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

@main
struct campfire_mobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
