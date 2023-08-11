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
    @Published var notificationsOn: Bool {
        didSet {
            
        }
    }
    
    init(notificationsOn: Bool) {
        self.notificationsOn = notificationsOn
    }
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
