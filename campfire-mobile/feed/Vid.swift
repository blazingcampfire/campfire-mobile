//
//  Vid.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/24/23.
//

import SwiftUI
import AVKit

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
}

enum MediaType: String, Codable {  //Allows a case to be setup to handle different Mediatypes
    case video
    case image
}

let MediaFileJSON = [
    MediaFile(url: "tyler", mediaType: .video),
    MediaFile(url: "blonde", mediaType: .image),
    MediaFile(url: "happen", mediaType: .video),
    MediaFile(url: "hot", mediaType: .image)
]

let PostFileJSON = [
    MediaFile(url: "cute", mediaType: .image)
]
//