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
    @Published var notifications: [UNNotification] = []
    
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
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
                        }
    }
    
    func sendNotification(title: String, subtitle: String) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        do {
            try await UNUserNotificationCenter.current().add(request)
        }
        catch {
            print(error)
        }
    }
}
