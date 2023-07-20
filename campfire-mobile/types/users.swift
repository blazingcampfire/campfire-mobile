//
//  users.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation

// every user profile should conform to this schema
public class Profile: Codable {
    var name: String?
    var phoneNumber: String
    var email: String
    var username: String
    var friends: [Profile]?
    var posts: [Post]?
    var chocs: Int
    var profilePicURL: String?
    var userID: String?
    
    init(name: String? = nil, phoneNumber: String, email: String, username: String, friends: [Profile]? = nil, posts: [Post]? = nil, chocs: Int, profilePicURL: String? = nil, userID: String? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.username = username
        self.friends = friends
        self.posts = posts
        self.chocs = chocs
        self.profilePicURL = profilePicURL
        self.userID = userID
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber
        case email
        case username
        case friends
        case posts
        case chocs
        case profilePicURL
        case userID
    }
}

public class privateUser: Codable {
    var phoneNumber: String
    var email: String
    var userID: String
    
    init(phoneNumber: String, email: String, userID: String) {
        self.phoneNumber = phoneNumber
        self.email = email
        self.userID = userID
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
