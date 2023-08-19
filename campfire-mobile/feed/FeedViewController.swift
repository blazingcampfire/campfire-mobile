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
    var newFeedModel: NewFeedModel
    var cancellables = Set<AnyCancellable>()


    init(currentUser: CurrentUserModel) {
        self.newFeedModel = NewFeedModel(currentUser: currentUser)
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
        
        print("View Safe Area Insets:", view.safeAreaInsets)
        print("Collection View Safe Area Insets:", collectionView.safeAreaInsets)
        
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCellIdentifier")
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCellIdentifier")
        
 
        newFeedModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
 

    func updateCollectionViewLayout() {
        print("update function went off ")
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
            layout.invalidateLayout()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for cell in collectionView.visibleCells {
            (cell as? VideoCollectionViewCell)?.player?.pause()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViewLayout()
        for cell in collectionView.visibleCells {
            (cell as? VideoCollectionViewCell)?.player?.play()
        }
    }
    
    
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(newFeedModel.posts.count)")
        return newFeedModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postItem = newFeedModel.posts[indexPath.item]
        
        if postItem.postType == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: postItem, model: newFeedModel, currentUser: newFeedModel.currentUser)
            return cell
        } else if postItem.postType == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCellIdentifier", for: indexPath) as! VideoCollectionViewCell
            cell.configure(with: postItem, model: newFeedModel, currentUser: newFeedModel.currentUser)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           if let videoCell = cell as? VideoCollectionViewCell {
               if !newFeedModel.pauseVideos {
                   videoCell.play()
               }
           }
           // Load more posts when the user is close to the end of the current list
           let threshold = 1 // How many more cells until the end to trigger the load more action
           if indexPath.item >= (newFeedModel.posts.count - threshold) {
               print("nearing the end")
               if !newFeedModel.reachedEndofData {
                   newFeedModel.loadMorePosts()
               }
           }
       }
       
      func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
          if let videoCell = cell as? VideoCollectionViewCell {
              videoCell.stop()
          }
      }
}


struct FeedViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var currentUser: CurrentUserModel
    
    func makeUIViewController(context: Context) -> FeedViewController {
        return FeedViewController(currentUser: currentUser)
    }
    
    typealias UIViewControllerType = FeedViewController
    
    func updateUIViewController(_ uiViewController: FeedViewController, context: Context) {
    }
    
}



