//
//  Vid.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/24/23.
//

import AVKit
import SwiftUI

struct Vid: Identifiable {    //This sets up the properties of the image or video that is displayed
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediafile: MediaFile
    var isPlaying: Bool = false
    var manuallyPaused: Bool = false
    
}
struct MediaFile: Identifiable {   //This separates the url from the initial Vid item, further simplifies what Vid has to handle
    var id = UUID().uuidString
    var url: String
    var mediaType: MediaType
    var isExpanded: Bool = false
    var posterUsername: String
    var posterProfilePic: String
    var postcaption: String  //going to grab the text from the caption text field
    var postLocation: String
    var postLikeCount: Int
    var commentCount: Int = diffComments.count
}

enum MediaType: String, Codable {  //Allows a case to be setup to handle different Mediatypes
    case video
    case image
}

struct PostsInfo {    //Connects each posts its own unique object so to keep track of each diff posts properties
    var id = UUID().uuidString
    var file: MediaFile
    var posterUsername: String
    var posterProfilePic: String
    var postcaption: String  //going to grab the text from the caption text field
    var postLocation: String
    var postLikeCount: Int
    var commentCount: Int = diffComments.count
}





//This array represents posts
let MediaFileJSON = [
    MediaFile(url: "sofrat", mediaType: .video, posterUsername: "ayowttf", posterProfilePic: "ragrboard6", postcaption: "bro's a dog", postLocation: "37 High St", postLikeCount: 12),
    MediaFile(url: "blonde", mediaType: .image, posterUsername: "sosexy", posterProfilePic: "ragrboard5", postcaption: "im so hot", postLocation: "88 Crown St", postLikeCount: 92)
]

let PostFileJSON = [
    MediaFile(url: "cute", mediaType: .image, posterUsername: "sosexy", posterProfilePic: "ragrboard5", postcaption: "im so hot", postLocation: "88 Crown St", postLikeCount: 92)
]
//
