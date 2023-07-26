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
    var phoneNumber: String
    var email: String
    var username: String
    var friends: [Profile]?
    var posts: [Data]
    var prompts: [String]
    var chocs: Int
    var profilePicURL: String?
    var userID: String
    var school: String
    var bio: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
    }
    
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.userID == rhs.userID && rhs.userID == lhs.userID
    }
    
    init(name: String, phoneNumber: String, email: String, username: String, friends: [Profile]? = nil, posts: [Data], prompts: [String], chocs: Int, profilePicURL: String? = nil, userID: String, school: String, bio: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.username = username
        self.friends = friends
        self.posts = posts
        self.prompts = prompts
        self.chocs = chocs
        self.profilePicURL = profilePicURL
        self.userID = userID
        self.school = school
        self.bio = bio
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber
        case email
        case username
        case friends
        case posts
        case prompts
        case chocs
        case profilePicURL
        case userID
        case school
        case bio
    }
}

public class privateUser: Codable {
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

//Firebase example
//public struct City: Codable {
//
//    let name: String
//    let state: String?
//    let country: String?
//    let isCapital: Bool?
//    let population: Int64?
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case state
//        case country
//        case isCapital = "capital"
//        case population
//    }
//
//}
