//
//  NotificationsManager.swift
//  campfire-mobile
//
//  Created by Toni on 7/25/23.
//

import Foundation
import UserNotifications
import UIKit

@MainActor
class NotificationsManager: ObservableObject {
    @Published var hasPermission = false
    
    init () {
        Task {
            await getAuthStatus()
        }
    }
    
    func request() async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        }
        catch {
            print(error)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized,
                .provisional,
                .ephemeral:
            hasPermission = true
        default:
            hasPermission = false
        }
    }
    
    func turnOffNotifications() async {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
}
