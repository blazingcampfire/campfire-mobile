//
//  SettingsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/26/23.
//

import Foundation
import FirebaseAuth

class SettingsModel {
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
