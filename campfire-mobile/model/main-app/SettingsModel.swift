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
    @Published var signedOut: Bool = false
    @Published var notificationsOn: Bool = false {
        didSet {
            Task {
                await NotificationsManager.shared.getAuthStatus()
                if notificationsOn && !NotificationsManager.shared.hasPermission {
                    await NotificationsManager.shared.request()
                }
                else if !notificationsOn && NotificationsManager.shared.hasPermission {
                    await NotificationsManager.shared.turnOffNotifications()
                }
            }
        }
    }
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
