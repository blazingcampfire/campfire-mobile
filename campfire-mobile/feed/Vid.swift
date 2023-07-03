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
}
struct MediaFile: Identifiable {
    var id = UUID().uuidString
    var url: String
    var isExpanded: Bool = false
}
let MediaFileJSON = [
    MediaFile(url: "david"),
    MediaFile(url: "adarsh"),
    MediaFile(url: "toni")
]

