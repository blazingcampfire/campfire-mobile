//
//  campfire_mobileApp.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// MARK: - Initializing Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    // MARK: - Phone Auth Initialization of Remote Notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
    //MARK: Google SignIn Auth
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    
}

@main
struct campfire_mobileApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
                ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
