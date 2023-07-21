//
//  users.swift
//  campfire-mobile
//
//  Created by Toni on 7/17/23.
//

import Foundation

// every user profile should conform to this schema
public struct Profile: Codable {
    var name: String?
    var phoneNumber: String
    var email: String
    var username: String
    var friends: [Profile]?
    var posts: [Post]?
    var chocs: Int
    var profilePicURL: String?
    var userID: String
    
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
