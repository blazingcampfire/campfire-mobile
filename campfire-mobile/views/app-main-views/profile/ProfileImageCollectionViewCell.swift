//
//  ProfileImageCollectionViewCell.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/7/23.
//


import Combine
import Kingfisher
import SwiftUI
import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var hostingController: UIHostingController<ProfileFeedUIView>?
    let likeButton = UIButton()
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

        // Set the button's state based on the post's like status
        if let individualPost = individualPostVM?.postItem {
            let hasLiked = individualPost.usersWhoLiked.contains(currentUser!.profile.userID)
            updateLikes(isLiked: hasLiked)
        }
    }

    @objc private func likeButtonTapped() {
        individualPostVM?.toggleLikeStatus()
    }

    func updateLikes(isLiked: Bool) {
        likeButton.isSelected = isLiked
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        // Pin the imageView to the edges of the cell
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(with postItem: PostItem, currentUser: CurrentUserModel) {
        self.currentUser = currentUser
        imageView.kf.setImage(with: URL(string: postItem.url))
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

