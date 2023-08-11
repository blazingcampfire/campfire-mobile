//
//  FeedPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/28/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import AVKit

class FeedPostModel: ObservableObject {
    @Published var posts = [PostItem]()
    @Published var postPlayers = [PostPlayer]()
    @Published var isNewFeedSelected: Bool = false {
        didSet {
            if isNewFeedSelected {
                listener?.remove()
                listenForNewFeedPosts()
            } else if !isNewFeedSelected {
                listener?.remove()
                listenForHotFeedPosts()
            }
        }
    }
    @Published var currentUser: CurrentUserModel
    var listener: ListenerRegistration?
    
    init(currentUser: CurrentUserModel) {
       self.currentUser = currentUser
       self.listenForNewFeedPosts()
    }
    
//    init(currentUser: CurrentUserModel) {
//        self.currentUser = currentUser
//    }
    
        
    func listenForNewFeedPosts() {
        let docRef = currentUser.postsRef.order(by: "date", descending: true)
    listener = docRef.addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                // map documents to PostItem
                self.posts = documents.map { queryDocumentSnapshot -> PostItem in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let caption = data["caption"] as? String ?? ""
                    let profilepic = data["profilepic"] as? String ?? ""
                    let url = data["url"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    let postType = data["postType"] as? String ?? ""
                    let date = data["date"] as? Timestamp ?? Timestamp()
                    let posterId = data["posterId"] as? String ?? ""
                    return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId)
                }

                // update postPlayers accordingly
                self.postPlayers = self.posts.compactMap { post in
                    if post.postType == "image" {
                        return PostPlayer(player: nil, postItem: post)
                    } else if post.postType == "video", let url = URL(string: post.url) {
                        let player = AVPlayer(url: url)
                        return PostPlayer(player: player, postItem: post)
                    } else {
                        return nil
                    }
                }
            }
        }

    func listenForHotFeedPosts() {
        let docRef = currentUser.postsRef.order(by: "numLikes", descending: true).order(by: "date", descending: true)
        
        listener = docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            // map documents to PostItem
            self.posts = documents.map { queryDocumentSnapshot -> PostItem in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let caption = data["caption"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                let postType = data["postType"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                let posterId = data["posterId"] as? String ?? ""
                return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId)
            } 

            // update postPlayers accordingly
            self.postPlayers = self.posts.compactMap { post in
                if post.postType == "image" {
                    return PostPlayer(player: nil, postItem: post)
                } else if post.postType == "video", let url = URL(string: post.url) {
                    let player = AVPlayer(url: url)
                    return PostPlayer(player: player, postItem: post)
                } else {
                    return nil
                }
            }
        }
    }
    
}
