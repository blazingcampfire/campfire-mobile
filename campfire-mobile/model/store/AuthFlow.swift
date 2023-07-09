//
//  LoginData.swift
//  campfire-mobile
//
//  Created by Toni on 7/8/23.
//

import Foundation

class newUser: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var profilePic: String = ""
}



