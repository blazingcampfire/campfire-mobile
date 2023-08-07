//
//  SettingsModel.swift
//  campfire-mobile
//
//  Created by Toni on 7/26/23.
//

import Foundation
import FirebaseAuth

class SettingsModel: ObservableObject {
    @Published var signedOut: Bool = false
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}
