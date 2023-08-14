//
//  FeedViewController.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import UIKit
import SwiftUI
import Firebase
import Combine

class FeedViewController: UIViewController {
    var collectionView: UICollectionView!
    var newFeedModel = NewFeedModel()
    var cancellable: AnyCancellable?

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
        
        // This ensures the collection view is edge-to-edge.
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCellIdentifier")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCellIdentifier")
        newFeedModel.listenForPosts()
        cancellable = newFeedModel.$feedPosts.sink { [unowned self] _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the frame to cover the entire screen
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newFeedModel.feedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = newFeedModel.feedPosts[indexPath.item]
       
        if post.postType == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: post, model: newFeedModel)
            return cell
        } else if post.postType == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCellIdentifier", for: indexPath) as! VideoCollectionViewCell
            cell.configure(with: post, model: newFeedModel)
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


