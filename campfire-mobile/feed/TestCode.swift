////
////  TestCode.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 8/13/23.
////
//
//import SwifUI
//
////
////  FeedViewController.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 8/12/23.
////
//
//import UIKit
//import SwiftUI
//import Firebase
//
//class FeedViewController: UIViewController {
//    var collectionView: UICollectionView!
//    var feedPosts: [String: PostItem] = [:]
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .black
//        collectionView.isPagingEnabled = true
//        collectionView.contentInsetAdjustmentBehavior = .never
//
//        // This ensures the collection view is edge-to-edge.
//        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//
//        view.addSubview(collectionView)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCellIdentifier")
//        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCellIdentifier")
//        getPosts()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        // Update the frame to cover the entire screen
//        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
//        }
//    }
//
//
//
//    func getPosts() {
//        let docRef = ndPosts
//        docRef.addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No documents")
//                return
//            }
//            var indexPathsToUpdate: [IndexPath] = []
//            var dataChanged = false
//
//            for document in documents {
//                let data = document.data()
//                let id = data["id"] as? String ?? ""
//                let username = data["username"] as? String ?? ""
//                let name = data["name"] as? String ?? ""
//                let caption = data["caption"] as? String ?? ""
//                let profilepic = data["profilepic"] as? String ?? ""
//                let url = data["url"] as? String ?? ""
//                let location = data["location"] as? String ?? ""
//                let postType = data["postType"] as? String ?? ""
//                let date = data["date"] as? Timestamp ?? Timestamp()
//                let posterId = data["posterId"] as? String ?? ""
//                let numLikes = data["numLikes"] as? Int ?? 0
//                let post = PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes)
//
//                if let existingPost = self.feedPosts[id] {
//                    if existingPost.numLikes != post.numLikes {
//                        self.feedPosts[id] = post
//                        if let index = Array(self.feedPosts.keys).sorted().firstIndex(of: id) {
//                            indexPathsToUpdate.append(IndexPath(item: index, section: 0))
//                        }
//                    }
//                } else {
//                    self.feedPosts[id] = post
//                    dataChanged = true
//                }
//            }
//            if dataChanged {
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//    }
//}
//
//extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return feedPosts.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let postKey = Array(feedPosts.keys).sorted()[indexPath.item]
//        guard let post = feedPosts[postKey] else {
//          return UICollectionViewCell()
//        }
//        if post.postType == "image" {
//              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as! ImageCollectionViewCell
//              if let imageURL = URL(string: post.url) {
//                 cell.configure(with: imageURL)
//              }
//              return cell
//        } else if post.postType == "video" {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCellIdentifier", for: indexPath) as! VideoCollectionViewCell
//            if let videoURL = URL(string: post.url) {
//                cell.configure(with: videoURL) // You'll have to define a configure method to handle video setup
//            }
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//
//}
//
//extension FeedViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//          if let videoCell = cell as? VideoCollectionViewCell {
//              videoCell.play()
//          }
//      }
//      func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//          if let videoCell = cell as? VideoCollectionViewCell {
//              videoCell.stop()
//          }
//      }
//}
//
//
//struct FeedViewControllerWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> FeedViewController {
//        return FeedViewController()
//    }
//
//    typealias UIViewControllerType = FeedViewController
//
//    func updateUIViewController(_ uiViewController: FeedViewController, context: Context) {
//    }
//
//}
//
//
//


//        likeTapped = false
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
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//           NSLayoutConstraint.activate([
//               likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//               likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//               likeButton.widthAnchor.constraint(equalToConstant: 30),
//               likeButton.heightAnchor.constraint(equalToConstant: 30)
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
//    }
//
//    @objc func handleLikeTap(_ sender: UIButton) {
//            // Handle the tap event, update Firestore and UI.
//            if likeTapped {
//                newFeedModel?.decreasePostLikes(postId: postId!)
//            } else {
//                newFeedModel?.increasePostLikes(postId: postId!)
//            }
//            likeTapped.toggle()
//            likeButton.setImage(UIImage(named: likeTapped ? "eatensmore" : "noteatensmore"), for: .normal)
//        }
