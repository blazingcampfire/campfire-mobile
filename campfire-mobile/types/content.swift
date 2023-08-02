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

struct Comment: Identifiable {
    var id: String
    var profilepic: String
    var username: String
    var comment: String
    var numLikes: Int
    var date: String
}

struct Reply: Identifiable, Hashable {
    var id: String
    var profilepic: String
    var username: String
    var reply: String
    var numLikes: Int
    var date: String
}
