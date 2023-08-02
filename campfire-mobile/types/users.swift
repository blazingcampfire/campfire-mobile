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

    // custom initializer to manually decode the Profile object
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        nameInsensitive = try container.decode(String.self, forKey: .nameInsensitive)
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        email = try container.decode(String.self, forKey: .email)
        username = try container.decode(String.self, forKey: .username)
        friends = try container.decodeIfPresent([Profile].self, forKey: .friends)
        posts = try container.decode([[String : String]].self, forKey: .posts)
        smores = try container.decode(Int.self, forKey: .smores)
        profilePicURL = try container.decode(String.self, forKey: .profilePicURL)
        userID = try container.decode(String.self, forKey: .userID)
        school = try container.decode(String.self, forKey: .school)
        bio = try container.decode(String.self, forKey: .bio)

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
