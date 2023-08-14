//
//  ImageCollectionViewCell.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import UIKit
import Kingfisher
import SwiftUI

class ImageCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    var likeButton: UIButton!
    var likeLabel: UILabel!
    var postId: String?
    var newFeedModel: NewFeedModel?
    var likeTapped = false
    var hostingController: UIHostingController<FeedUIView>?
    
    
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
        imageView.backgroundColor = .clear
        contentView.addSubview(imageView)

        
        // Pin the imageView to the edges of the cell
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with post: PostItem, model: NewFeedModel) {
        imageView.kf.setImage(with: URL(string: post.url))
        if let swiftUIView = hostingController?.view {
            swiftUIView.removeFromSuperview()
        }
        
        let overlayView = FeedUIView(post: post)
        hostingController = UIHostingController(rootView: overlayView)

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
        likeTapped = false
        postId = post.id
        newFeedModel = model
        
        if likeButton == nil {
            likeButton = UIButton(type: .system)
            likeButton.addTarget(self, action: #selector(handleLikeTap(_:)), for: .touchUpInside)
            contentView.addSubview(likeButton)
        }
        
        likeButton.setImage(UIImage(named: likeTapped ? "eatensmore" : "noteatensmore"), for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
               likeButton.widthAnchor.constraint(equalToConstant: 30),
               likeButton.heightAnchor.constraint(equalToConstant: 30)
           ])
        
        if likeLabel == nil {
            likeLabel = UILabel()
            contentView.addSubview(likeLabel)
        }
        updateLikes(post.numLikes)
    }
    
    func updateLikes(_ likes: Int) {
        likeLabel.text = "\(likes)"
    }
    
    @objc func handleLikeTap(_ sender: UIButton) {
            // Handle the tap event, update Firestore and UI.
            if likeTapped {
                newFeedModel?.decreasePostLikes(postId: postId!)
            } else {
                newFeedModel?.increasePostLikes(postId: postId!)
            }
            likeTapped.toggle()
            likeButton.setImage(UIImage(named: likeTapped ? "eatensmore" : "noteatensmore"), for: .normal)
        }

}

