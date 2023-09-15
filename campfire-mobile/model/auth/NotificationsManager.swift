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
import FirebaseAuth

@MainActor
class NotificationsManager: ObservableObject {
    @Published private(set) var hasPermission = false
    @Published var notifications: [UNNotification] = []
    @Published var token: String = ""
    init() {
        Task {
            await getAuthStatus()
            getToken()
        }
    }

    func request() async {
        do {
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            getToken()
            print(token)
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

    func sendLocalNotification(title: String, subtitle: String) async {
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
    
    func getToken() {
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
              self.token = token
            print("FCM registration token: \(token)")
          }
        }
    }
    
    func updateToken(school: String) {
        let notificationsRef = notificationsParser(school: school)
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let userToken = notificationsRef?.document(userID)
        
        userToken?.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    let data = document.data()
                    let token = data?["fcmToken"] as? String ?? ""
                    print(token)
                    if(self.token == token) {
                        return
                    }
                    else {
                        userToken?.setData(["fcmToken": self.token])
                    }
                }
                else {
                    userToken?.setData(["fcmToken": self.token])
                    print("successful write")
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}
