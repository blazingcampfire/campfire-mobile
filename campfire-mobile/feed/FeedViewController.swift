//
//  FeedViewController.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseFirestore
import Combine

class FeedViewController: UIViewController {
    var collectionView: UICollectionView!
    var newFeedModel = NewFeedModel()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCellIdentifier")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCellIdentifier")
        newFeedModel.fetchInitialPosts()
        
        newFeedModel.initialPostsLoaded.sink { [weak self] _ in
        self?.collectionView.reloadData()
        }.store(in: &cancellables)
        
        newFeedModel.listenForPosts()
        newFeedModel.$updatedPostIndex.sink { [weak self] index in
            guard let index = index else { return }
            DispatchQueue.main.async {
                self?.updateLikes(for: index)
            }
        }.store(in: &cancellables)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
}

extension FeedViewController {
    func updateLikes(for index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        let postItem = newFeedModel.posts[index]
        
        if let imageCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell,
           let individualPostVM = imageCell.individualPostVM {
            imageCell.updateLikes(isLiked: individualPostVM.isLiked)
        } else if let videoCell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell,
                  let individualPostVM = videoCell.individualPostVM {
            videoCell.updateLikes(isLiked: individualPostVM.isLiked)
        }
        // Update likes count label here, if needed
    }
}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(newFeedModel.posts.count)")
        return newFeedModel.posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Configuring cell for item at: \(indexPath.item)")
        let postItem = newFeedModel.posts[indexPath.item]
        print("2. Configuring cell for item at: \(indexPath.item)")
        
        if postItem.postType == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: postItem)
            return cell
        } else if postItem.postType == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCellIdentifier", for: indexPath) as! VideoCollectionViewCell
            cell.configure(with: postItem)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          if let videoCell = cell as? VideoCollectionViewCell {
              videoCell.play()
          }
      }
      func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          if let videoCell = cell as? VideoCollectionViewCell {
              videoCell.stop()
          }
      }
}


struct FeedViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FeedViewController {
        return FeedViewController()
    }
    
    typealias UIViewControllerType = FeedViewController
    
    func updateUIViewController(_ uiViewController: FeedViewController, context: Context) {
    }
    
}


