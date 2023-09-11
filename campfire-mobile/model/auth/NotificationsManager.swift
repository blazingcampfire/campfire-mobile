//
//  NotificationsManager.swift
//  campfire-mobile
//
//  Created by Toni on 7/25/23.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging

@MainActor
class NotificationsManager: ObservableObject {
    @Published private(set) var hasPermission = false
    @Published var notifications: [UNNotification] = []
    @Published var token: String = ""
    init() {
        Task {
            await getAuthStatus()
        }
    }

    func request() async {
        do {
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return
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
        } catch {
            return
        }
    }
    
//    func sendNotification(to fcmToken: String, title: String, body: String) {
//        let urlString = "https://fcm.googleapis.com/fcm/send"
//        let url = URL(string: urlString)!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
//
//        let message: [String: Any] = [
//            "to": fcmToken,
//            "notification": [
//                "title": title,
//                "body": body
//            ]
//        ]
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: message, options: [])
//            request.httpBody = jsonData
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error sending notification: \(error)")
//                } else {
//                    print("Notification sent successfully")
//                }
//            }.resume()
//        } catch {
//            print("Error creating JSON data: \(error)")
//        }
//    }

    func getToken (){
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              self.token = token
            print("FCM registration token: \(token)")
          }
        }
    }

}
