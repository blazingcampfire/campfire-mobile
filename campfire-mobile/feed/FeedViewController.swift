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
    var currentInteractingIndexPath: IndexPath?

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
        
        newFeedModel.$posts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
  //      observePauseVideos()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
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
        for cell in collectionView.visibleCells {
            (cell as? VideoCollectionViewCell)?.player?.play()
        }
    }
    
//    func observePauseVideos() {
//        newFeedModel.$pauseVideos
//            .sink { [weak self] isPaused in
//                guard let self = self else { return }
//
//                if !isPaused, let indexPath = self.currentInteractingIndexPath {
//                    print("scrolled back to correct item")
//                    self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
//                }
//            }
//            .store(in: &cancellables)
//    }

}


extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(newFeedModel.posts.count)")
        return newFeedModel.posts.count
    }
    
    func currentVisibleIndexPath() -> IndexPath? {
            for cell in collectionView.visibleCells {
                if let indexPath = collectionView.indexPath(for: cell) {
                    return indexPath
                }
            }
            return nil
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postItem = newFeedModel.posts[indexPath.item]
        
        if postItem.postType == "image" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageCollectionViewCell
            cell.configure(with: postItem, model: newFeedModel)
            return cell
        } else if postItem.postType == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCellIdentifier", for: indexPath) as! VideoCollectionViewCell
            cell.configure(with: postItem, model: newFeedModel)
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

extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = currentVisibleIndexPath() else { return }
        currentInteractingIndexPath = indexPath
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

struct KeyboardSafeAreaKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
extension EnvironmentValues {
    var keyboardSafeArea: CGFloat {
        get { self[KeyboardSafeAreaKey.self] }
        set { self[KeyboardSafeAreaKey.self] = newValue }
    }
}

