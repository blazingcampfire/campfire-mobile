//
//  ViewController.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/7/23.
//

import Combine
import Firebase
import FirebaseFirestore
import SwiftUI
import UIKit

class ProfileFeedViewController: UIViewController {
    var collectionView: UICollectionView!
    var cancellables = Set<AnyCancellable>()
    var profilePosts: ProfileFeedPosts

    init(userID: String, currentUser: CurrentUserModel) {
        profilePosts = ProfileFeedPosts(userID: userID, currentUser: currentUser)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
   
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileImageCellIdentifier")
        collectionView.register(ProfileVideoCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileVideoCellIdentifier")
        collectionView.register(EmptyPostCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyPosts")
        
        print("Creating dismissal button")
        let dismissalButton = UIButton(type: .system)
        dismissalButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        dismissalButton.tintColor = .white
        dismissalButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        // Calculate the button's position (e.g., 16 points from the top and centered horizontally)
        let buttonSize: CGFloat = 100.0 // Adjust the button's size as needed
        let buttonX = (view.frame.width - buttonSize + 320) / 2.0
        let buttonY: CGFloat = 0

        // Set the button's frame (optional, for clarity, but not used with transform)
        dismissalButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonSize, height: buttonSize)

        // Apply a scale transform to the button to make it visually bigger
        let scale: CGFloat = 2.0 // Adjust the scale factor as needed
        dismissalButton.transform = CGAffineTransform(scaleX: scale, y: scale)

        // Add the dismissal button to the view
        view.addSubview(dismissalButton)

        profilePosts.$profilePosts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc func dismissViewController() {
        print("dismiss tapped")
        self.navigationController?.popViewController(animated: true)
    }

    
    
    func updateCollectionViewLayout() {
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
            layout.invalidateLayout()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for cell in collectionView.visibleCells {
            (cell as? ProfileVideoCollectionViewCell)?.player?.pause()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViewLayout()
        for cell in collectionView.visibleCells {
            (cell as? ProfileVideoCollectionViewCell)?.player?.play()
        }
    }
}

extension ProfileFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if profilePosts.profilePosts.isEmpty {
            return 1 // Return 1 for the EmptyPostCollectionViewCell
        } else {
            return profilePosts.profilePosts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if profilePosts.profilePosts.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyPosts", for: indexPath) as! EmptyPostCollectionViewCell
            print("no posts")
            return cell
        } else {
            let postItem = profilePosts.profilePosts[indexPath.item]
            if postItem.postType == "image" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCellIdentifier", for: indexPath) as! ProfileImageCollectionViewCell
                cell.configure(with: postItem, currentUser: profilePosts.currentUser)
                return cell
            } else if postItem.postType == "video" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileVideoCellIdentifier", for: indexPath) as! ProfileVideoCollectionViewCell
                cell.configure(with: postItem, currentUser: profilePosts.currentUser)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension ProfileFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? ProfileVideoCollectionViewCell {
            videoCell.play()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? ProfileVideoCollectionViewCell {
            videoCell.stop()
        }
    }
}

struct ProfileFeedViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var currentUser: CurrentUserModel
    var userID: String
    
    func makeUIViewController(context: Context) -> ProfileFeedViewController {
        return ProfileFeedViewController(userID: userID, currentUser: currentUser)
    }

    typealias UIViewControllerType = ProfileFeedViewController

    func updateUIViewController(_ uiViewController: ProfileFeedViewController, context: Context) {
    }
}


