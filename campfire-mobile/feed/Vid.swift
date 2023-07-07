//
//  Vid.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/24/23.
//

import SwiftUI
import AVKit

struct Vid: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediafile: MediaFile
    var isPlaying: Bool = false
    var manuallyPaused: Bool = false
    
}
struct MediaFile: Identifiable {
    var id = UUID().uuidString
    var url: String
    var mediaType: MediaType
    var isExpanded: Bool = false
}

enum MediaType: String, Codable {
    case video
    case image
}

let MediaFileJSON = [
    MediaFile(url: "tyler", mediaType: .video),
    MediaFile(url: "me", mediaType: .image),
    MediaFile(url: "happen", mediaType: .video),
    MediaFile(url: "hot", mediaType: .image)
]

