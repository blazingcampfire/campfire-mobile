//
//  users.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import UIKit

// every user profile should conform to this schema
public class Profile: Codable, Hashable {

    var name: String
    var nameInsensitive: String
    var phoneNumber: String
    var email: String
    var username: String
    var friends: [Profile]?
    var posts: [[String : String]] // posts: [[postImage: Prompt]]
    var smores: Int
    var profilePicURL: String
    var userID: String
    var school: String
    var bio: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }

    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.userID == rhs.userID && rhs.userID == lhs.userID
    }

    init(name: String, nameInsensitive: String, phoneNumber: String, email: String, username: String, friends: [Profile]? = nil, posts: [[String: String]], smores: Int, profilePicURL: String, userID: String, school: String, bio: String) {
        self.name = name
        self.nameInsensitive = nameInsensitive
        self.phoneNumber = phoneNumber
        self.email = email
        self.username = username
        self.friends = friends
        self.posts = posts
        self.smores = smores
        self.profilePicURL = profilePicURL
        self.userID = userID
        self.school = school
        self.bio = bio
    }
}


public class PrivateUser: Codable {
    var phoneNumber: String
    var email: String
    var userID: String
    var school: String

    init(phoneNumber: String, email: String, userID: String, school: String) {
        self.phoneNumber = phoneNumber
        self.email = email
        self.userID = userID
        self.school = school
    }
}

public class Request: Codable {
    var name: String
    var username: String
    var profilePicURL: String
    
    init(name: String, username: String, profilePicURL: String) {
        self.name = name
        self.username = username
        self.profilePicURL = profilePicURL
    }
}
