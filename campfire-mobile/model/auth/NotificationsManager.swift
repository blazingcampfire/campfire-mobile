//
//  NotificationsManager.swift
//  campfire-mobile
//
//  Created by Toni on 7/25/23.
//

import Foundation
import UserNotifications

class NotificationsManager: ObservableObject {
    
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
    }
}
