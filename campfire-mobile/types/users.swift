//
//  users.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation

// every user profile should conform to this schema
struct Profile: Codable {
    var name: String?
    var phoneNumber: String
    var email: String
    var username: String
    var bio: String
    var friends: [Profile]?
    var posts: [Post]?
    var chocs: Int
    var profilePicURL: String?
    var userID: String?
}

