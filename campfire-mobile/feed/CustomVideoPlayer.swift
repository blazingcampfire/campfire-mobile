//
//  CustomVideoPlayer.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/24/23.
//

import AVKit
import SwiftUI


//This sets up the unique videoplayer that doesn't show the playback features and has ability to handle user interaction

struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    @Binding var isPlaying: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.player = player

        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(context.coordinator.restartPlayback), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }

    class Coordinator: NSObject {
        var parent: CustomVideoPlayer

        init(parent: CustomVideoPlayer) {
            self.parent = parent
        }

        @objc func restartPlayback() {
            parent.player.seek(to: .zero)
            parent.player.play()
        }
    }
}
