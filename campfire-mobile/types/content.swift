//
//  FeedPostStructure.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/28/23.
//

import AVKit
import Firebase
import SwiftUI
import UIKit

struct PostItem: Identifiable, Equatable {
    var id: String
    var username: String
    var name: String
    var caption: String
    var profilepic: String
    var url: String
    var location: String
    var postType: String
    var date: Timestamp
    var posterId: String
    var numLikes: Int
    var comNum: Int
    var score: Int
    var usersWhoLiked: [String]
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
    var date: Timestamp
    var posterId: String
    var numLikes: Int
    var usersWhoLiked: [String]
}

struct Reply: Identifiable {
    var id: String
    var profilepic: String
    var username: String
    var reply: String
    var date: Timestamp
    var posterId: String
    var numLikes: Int
    var usersWhoLiked: [String]
}

func postTimeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)

    if components.year! >= 2 {
        return "\(components.year!) years ago"
    } else if components.year! >= 1 {
        if numericDates {
            return "1 year ago"
        } else {
            return "last year"
        }
    } else if components.month! >= 2 {
        return "\(components.month!) months ago"
    } else if components.month! >= 1 {
        if numericDates {
            return "1 month ago"
        } else {
            return "last month"
        }
    } else if components.weekOfYear! >= 2 {
        return "\(components.weekOfYear!) weeks ago"
    } else if components.weekOfYear! >= 1 {
        if numericDates {
            return "1 week ago"
        } else {
            return "last week"
        }
    } else if components.day! >= 2 {
        return "\(components.day!) days ago"
    } else if components.day! >= 1 {
        if numericDates {
            return "1 day ago"
        } else {
            return "yesterday"
        }
    } else if components.hour! >= 2 {
        return "\(components.hour!) hours ago"
    } else if components.hour! >= 1 {
        if numericDates {
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if components.minute! >= 2 {
        return "\(components.minute!) mins ago"
    } else if components.minute! >= 1 {
        if numericDates {
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if components.second! >= 3 {
        return "\(components.second!) seconds ago"
    } else {
        return "just now"
    }
}

func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components: DateComponents = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year, .second], from: earliest, to: latest)

    if components.year! >= 2 {
        return "\(components.year!)y"
    } else if components.year! >= 1 {
        if numericDates {
            return "1y"
        } else {
            return "Last year"
        }
    } else if components.month! >= 2 {
        return "\(components.month!)m"
    } else if components.month! >= 1 {
        if numericDates {
            return "1m"
        } else {
            return "Last month"
        }
    } else if components.weekOfYear! >= 2 {
        return "\(components.weekOfYear!)w"
    } else if components.weekOfYear! >= 1 {
        if numericDates {
            return "1w"
        } else {
            return "Last week"
        }
    } else if components.day! >= 2 {
        return "\(components.day!)d"
    } else if components.day! >= 1 {
        if numericDates {
            return "1d"
        } else {
            return "Yesterday"
        }
    } else if components.hour! >= 2 {
        return "\(components.hour!)h"
    } else if components.hour! >= 1 {
        if numericDates {
            return "1h"
        } else {
            return "An hour ago"
        }
    } else if components.minute! >= 2 {
        return "\(components.minute!)min"
    } else if components.minute! >= 1 {
        if numericDates {
            return "1min"
        } else {
            return "A minute ago"
        }
    } else if components.second! >= 3 {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
}

struct Player: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> some AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.player.seek(to: .zero)
            self.player.play()
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct PlayerTwo: UIViewControllerRepresentable {
    @Binding var shouldPlay: Bool
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.player.seek(to: .zero)
            if self.shouldPlay {
                self.player.play()
            }
        }
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        if shouldPlay {
            playerController.player?.play()
        } else {
            playerController.player?.pause()
        }
    }

    func dismantleUIViewController(_ uiViewController: AVPlayerViewController, coordinator: Coordinator) {
        NotificationCenter.default.removeObserver(uiViewController, name: .AVPlayerItemDidPlayToEndTime, object: uiViewController.player?.currentItem)
    }
}
