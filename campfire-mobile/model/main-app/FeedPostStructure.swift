//
//  FeedPostStructure.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/28/23.
//

import SwiftUI
import AVKit

struct PostItem: Identifiable {
    var id: String
    var username: String
    var name: String
    var caption: String
    var profilepic: String
    var url: String
    var numLikes: Int
    var location: String
    var comments: [String]
    var postType: String
}

struct PostPlayer: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var postItem: PostItem
}


//let photoDocData: [String: Any] = [
//    "username": "davooo",
//    "name": "David Adebogun",
//    "caption": "yoo",    //pass captiontextfield text into here
//    "profilepic": "", // some path to the user's profile pic
//    "url": path,
//    "numLikes": 0,
//    "location": "",  //some string creation of location
//    "comments": [""],
//]
