//
//  SettingsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/26/23.
//

import Foundation
import FirebaseAuth

@MainActor
class SettingsModel: ObservableObject {
    @Published var notificationsManager: NotificationsManager
    @Published var signedOut: Bool = false
    @Published var notificationsOn: Bool {
        didSet {
            print(notificationsOn)
            Task {
                await setNotificationsStatus()
            }
        }
    }
    
    init(notificationsOn: Bool, notificationsManager: NotificationsManager) {
        self.notificationsOn = notificationsOn
        self.notificationsManager = notificationsManager
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func setNotificationsStatus() async {
        Task {
            await notificationsManager.getAuthStatus()
            if notificationsOn && !notificationsManager.hasPermission {
                await notificationsManager.request()
            }
            else if !notificationsOn && notificationsManager.hasPermission {
                await notificationsManager.turnOffNotifications()
            }
        }
    }
}
