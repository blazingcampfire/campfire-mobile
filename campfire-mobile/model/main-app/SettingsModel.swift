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
    
//    func deleteAccount() async throws {
//        if Auth.auth().currentUser?.email == nil {
//            throw EmailError.noExistingUser
//        }
//        else {
//            do {
//                AuthenticationManager.shared.deleteAllUserData(currentUser: currentUser)
//                print("successfully deleted user data")
//                AuthenticationManager.shared.deleteUser()
//                try AuthenticationManager.shared.signOut()
//            }
//            catch {
//                self.deleteErrorAlert = true
//            }
//        }
//    }
}
