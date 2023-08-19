//
//  SettingsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/26/23.
//

import Foundation
import FirebaseAuth
import UIKit

@MainActor
class SettingsModel: ObservableObject {
    @Published var currentUser: CurrentUserModel
    @Published var notificationsManager: NotificationsManager
    @Published var signedOut: Bool = false
    @Published var deleteErrorAlert: Bool = false
    @Published var notificationsOn: Bool {
        didSet {
            print(notificationsOn)
            Task {
                await setNotificationsStatus()
            }
        }
    }
    
    init(currentUser: CurrentUserModel, notificationsOn: Bool, notificationsManager: NotificationsManager) {
        self.currentUser = currentUser
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
    
    func openMail(emailTo:String, subject: String, body: String) {
        if let url = URL(string: "mailto:\(emailTo)?subject=\(subject.fixToBrowserString())&body=\(body.fixToBrowserString())"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
// fixToBrowserString extension
extension String {
    func fixToBrowserString() -> String {
        self.replacingOccurrences(of: ";", with: "%3B")
            .replacingOccurrences(of: "\n", with: "%0D%0A")
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: "!", with: "%21")
            .replacingOccurrences(of: "\"", with: "%22")
            .replacingOccurrences(of: "\\", with: "%5C")
            .replacingOccurrences(of: "/", with: "%2F")
            .replacingOccurrences(of: "‘", with: "%91")
            .replacingOccurrences(of: ",", with: "%2C")
            //more symbols fixes here: https://mykindred.com/htmlspecialchars.php
    }
}
