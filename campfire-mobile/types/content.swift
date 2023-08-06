//
//  FeedPostStructure.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/28/23.
//

import SwiftUI
import AVKit
import Firebase

//Update to have user id field
struct PostItem: Identifiable {
    var id: String
    var username: String
    var name: String
    var caption: String
    var profilepic: String
    var url: String
    var numLikes: Int
    var location: String
    var postType: String
    var date: Timestamp
}

struct PostPlayer: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var postItem: PostItem
}

//Update to have user id field
struct Comment: Identifiable {
    var id: String
    var profilepic: String
    var username: String
    var comment: String
    var numLikes: Int
    var date: Timestamp
}
//Update to have user id field
struct Reply: Identifiable, Hashable {
    var id: String
    var profilepic: String
    var username: String
    var reply: String
    var numLikes: Int
    var date: Timestamp
}

func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)

    if (components.year! >= 2) {
        return "\(components.year!)y"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1y"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!)m"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1m"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)w"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1w"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!)d"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1d"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!)h"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1h"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!)min"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1min"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
}

