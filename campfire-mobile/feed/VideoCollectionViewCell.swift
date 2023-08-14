//
//  VideoCollectionViewCell.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import UIKit
import AVKit
import SwiftUI

class VideoCollectionViewCell: UICollectionViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    //    var likeButton: UIButton!
    //    var likeLabel: UILabel!
    //    var postId: String?
    //    var newFeedModel: NewFeedModel?
    //    var likeTapped = false
    
    var hostingController: UIHostingController<FeedUIView>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        //        likeTapped = false
        //        postId = nil
        //        newFeedModel = nil
    }
    
    private func setupPlayerLayer() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else { return }
        
        playerLayer.videoGravity = .resizeAspectFill
        contentView.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    @objc private func videoDidEnd(notification: NSNotification) {
        guard let playerItem = player?.currentItem, notification.object as? AVPlayerItem == playerItem else {
            return
        }
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }
    
    func configure(with post: PostItem, model: NewFeedModel) {
        let playerItem = AVPlayerItem(url: URL(string: post.url)!)
        player?.replaceCurrentItem(with: playerItem)
        if let swiftUIView = hostingController?.view {
            swiftUIView.removeFromSuperview()
        }
        
        if hostingController == nil {
            let overlayView = FeedUIView(post: post)
            hostingController = UIHostingController(rootView: overlayView)
        }
        
        guard let swiftUIView = hostingController?.view else { return }
        swiftUIView.backgroundColor = .clear  // Ensure the UIKit hosting view is also clear
        
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(swiftUIView)
        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: contentView.topAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        //        likeTapped = model.likedPosts[post.id, default: false]
        //        postId = post.id
        //        newFeedModel = model
        //
        //        if likeButton == nil {
        //            likeButton = UIButton(type: .system)
        //            likeButton.addTarget(self, action: #selector(handleLikeTap(_:)), for: .touchUpInside)
        //            contentView.addSubview(likeButton)
        //        }
        //
        //        likeButton.setImage(UIImage(named: likeTapped ? "eatensmore" : "noteatensmore"), for: .normal)
        //        likeButton.tintColor = .none
        //        likeButton.translatesAutoresizingMaskIntoConstraints = false
        //           NSLayoutConstraint.activate([
        //               likeButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -350),
        //               likeButton.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
        //               likeButton.widthAnchor.constraint(equalToConstant: 60),
        //               likeButton.heightAnchor.constraint(equalToConstant: 60)
        //           ])
        //
        //        if likeLabel == nil {
        //            likeLabel = UILabel()
        //            contentView.addSubview(likeLabel)
        //        }
        //        updateLikes(post.numLikes)
        //    }
        //
        //    func updateLikes(_ likes: Int) {
        //        likeLabel.text = "\(likes)"
        //      //  likeLabel.font = "LexendDeca-Regular"
        //    }
        //
        //    @objc func handleLikeTap(_ sender: UIButton) {
        //        // Handle the tap event, update Firestore and UI.
        //        likeTapped.toggle()
        //        if likeTapped {
        //            newFeedModel?.increasePostLikes(postId: postId!)
        //            newFeedModel?.likedPosts[postId!] = true
        //        } else {
        //            newFeedModel?.decreasePostLikes(postId: postId!)
        //            newFeedModel?.likedPosts[postId!] = false
        //        }
        //
        //        updateLikes(newFeedModel?.likedPosts.count ?? 0)
        //
        //        let imageName = newFeedModel?.likedPosts[postId!] ?? false ? "eatensmore" : "noteatensmore"
        //        likeButton.setImage(
        //            UIImage(named: imageName),
        //            for: .normal
        //        )
        //        if let updatedPost = newFeedModel?.feedPosts.first(where: { $0.id == postId }) {
        //            // Update the likes label in UI
        //            updateLikes(updatedPost.numLikes)
        //        }
        //    }
        
    }
}


extension VideoCollectionViewCell {
    func play() {
        player?.play()
    }
    func stop() {
        player?.pause()
    }
}
