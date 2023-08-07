//
//  users.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

// every user profile should conform to this schema
class Profile: Codable, Hashable {

    var name: String
    var nameInsensitive: String
    var phoneNumber: String
    var email: String
    var username: String
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

    init(name: String, nameInsensitive: String, phoneNumber: String, email: String, username: String,  posts: [[String: String]], smores: Int, profilePicURL: String, userID: String, school: String, bio: String) {
        self.name = name
        self.nameInsensitive = nameInsensitive
        self.phoneNumber = phoneNumber
        self.email = email
        self.username = username
        self.posts = posts
        self.smores = smores
        self.profilePicURL = profilePicURL
        self.userID = userID
        self.school = school
        self.bio = bio
    }

}
// extends profile search by adding a bool which indicates whether the current user has requested a friendship with a given user returned from a search
class ProfileSearch: Profile {
    var requested: Bool
    
    init(name: String, nameInsensitive: String, phoneNumber: String, email: String, username: String, posts: [[String : String]], smores: Int, profilePicURL: String, userID: String, school: String, bio: String, requested: Bool) {
        self.requested = requested
        super.init(name: name, nameInsensitive: nameInsensitive, phoneNumber: phoneNumber, email: email, username: username, posts: posts, smores: smores, profilePicURL: profilePicURL, userID: userID, school: school, bio: bio)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}


class PrivateUser: Codable {
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

class PrivateUserFirestore: Codable {
    var phoneNumber: String
    var email: String
    var userID: String
    var school: String
    
    init?(data: [String: Any]) {
        guard let phoneNumber = data["phoneNumber"] as? String,
              let email = data["email"] as? String,
              let userID = data["userID"] as? String,
              let school = data["school"] as? String else {
            return nil
        }
        self.phoneNumber = phoneNumber
        self.email = email
        self.userID = userID
        self.school = school
    }
}


class Request: Codable, Hashable {
    var userID: String?
    var name: String
    var username: String
    var profilePicURL: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }

    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.userID == rhs.userID && rhs.userID == lhs.userID
    }
    
    init(userID: String? = nil, name: String, username: String, profilePicURL: String) {
        self.userID = userID
        self.name = name
        self.username = username
        self.profilePicURL = profilePicURL
    }
    
    
}

class RequestFirestore: Codable, Hashable {
    var userID: String?
    var name: String
    var username: String
    var profilePicURL: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }

    public static func == (lhs: RequestFirestore, rhs: RequestFirestore) -> Bool {
        return lhs.userID == rhs.userID && rhs.userID == lhs.userID
    }
    
    init?(data: [String: Any]) {
        guard let userID = data["userID"] as? String,
              let name = data["name"] as? String,
              let username = data["username"] as? String,
              let profilePicURL = data["profilePicURL"] as? String else {
            return nil
        }
        self.userID = userID
        self.name = name
        self.username = username
        self.profilePicURL = profilePicURL
    }
}

