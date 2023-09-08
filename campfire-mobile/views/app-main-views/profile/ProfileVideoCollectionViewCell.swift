//
//  ProfileVideoCollectionViewCell.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/7/23.
//

import AVKit
import Combine
import SwiftUI
import UIKit

class ProfilePlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}

class ProfileVideoCollectionViewCell: UICollectionViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var hostingController: UIHostingController<ProfileFeedUIView>?
    let likeButton = UIButton()
    let playerView = ProfilePlayerView()
    var individualPostVM: IndividualPost? {
        didSet {
            setupBindings()
        }
    }

    var cancellables = Set<AnyCancellable>()
    var currentUser: CurrentUserModel?

    private func setupBindings() {
        cancellables = []
        guard let viewModel = individualPostVM else { return }
        viewModel.$isLiked
            .assign(to: \.isSelected, on: likeButton)
            .store(in: &cancellables)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerLayer()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerLayer()
        setupGestureRecognizers()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player?.seek(to: .zero)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }

    private func setupPlayerView() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    @objc private func likeButtonTapped() {
        individualPostVM?.toggleLikeStatus()
    }

    func updateLikes(isLiked: Bool) {
        likeButton.isSelected = isLiked
    }

    private func setupLikeButton() {
        likeButton.setImage(UIImage(named: "noteatensmore"), for: .normal)
        likeButton.setImage(UIImage(named: "eatensmore"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -325), // 10 points from the bottom
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // 10 points from the trailing side
        ])

        if let individualPost = individualPostVM?.postItem {
            let hasLiked = individualPost.usersWhoLiked.contains(currentUser!.profile.userID)
            updateLikes(isLiked: hasLiked)
        }
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

    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc func handleTap() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = contentView.bounds
    }

    func configure(with postItem: PostItem, currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        // Safely unwrap the URL string
        if let url = URL(string: postItem.url) {
            let playerItem = AVPlayerItem(url: url)

            // Replace the current player item with the new item
            player?.replaceCurrentItem(with: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }

    
        if let swiftUIView = hostingController?.view {
            swiftUIView.removeFromSuperview()
        }

        individualPostVM = IndividualPost(postItem: postItem, currentUser: currentUser)

        if let swiftUIView = hostingController?.view {
            swiftUIView.removeFromSuperview()
        }

        if let individualPostVM = individualPostVM {
            let overlayView = ProfileFeedUIView(individualPost: individualPostVM)
            hostingController = UIHostingController(rootView: overlayView)

            guard let swiftUIView = hostingController?.view else { return }
            swiftUIView.backgroundColor = .clear
            swiftUIView.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(swiftUIView)

            NSLayoutConstraint.activate([
                swiftUIView.topAnchor.constraint(equalTo: contentView.topAnchor),
                swiftUIView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                swiftUIView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                swiftUIView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
            // Move this line here to ensure that the likeButton is rendered above swiftUIView
            setupLikeButton()
        }
    }
}

extension ProfileVideoCollectionViewCell {
    func play() {
        player?.play()
    }

    func stop() {
        player?.pause()
    }
}

