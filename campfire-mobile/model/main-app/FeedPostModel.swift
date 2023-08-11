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
    @Published var isNewFeedSelected: Bool = false
    @Published var currentUser: CurrentUserModel
    @Published var hotPosts = [PostItem]()
    @Published var newPosts = [PostItem]()
    @Published var hotPostPlayers = [PostPlayer]()
    @Published var newPostPlayers = [PostPlayer]()
    @Published var lastSnapShot: DocumentSnapshot?
    @Published var lastHotSnapShot: DocumentSnapshot?
    
    

    var currentPostPlayers: [PostPlayer] {
        isNewFeedSelected ? newPostPlayers : hotPostPlayers
    }
    
    var hotListener: ListenerRegistration?
    var newListener: ListenerRegistration?
    
    init(currentUser: CurrentUserModel) {
       self.currentUser = currentUser
       self.listenForHotFeedPosts()
       self.listenForNewFeedPosts()
    }
    
    deinit {
        newListener?.remove()
        hotListener?.remove()
    }
    
    
        
    func listenForNewFeedPosts() {
        var docRef = ndPosts.order(by: "date", descending: true).limit(to: 2)
        
        if let lastSnap = lastSnapShot {
            docRef = docRef.start(afterDocument: lastSnap)
        }
        
        self.newListener = docRef.addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
            self.lastSnapShot = querySnapshot?.documents.last
            
                // map documents to PostItem
                let newPosts = documents.map { queryDocumentSnapshot -> PostItem in
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
            
                self.newPosts.append(contentsOf: newPosts)

                // update postPlayers accordingly
                self.newPostPlayers = self.newPosts.compactMap { post in
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
        var docRef = ndPosts.order(by: "date", descending: false).limit(to: 2)
        
        if let lastSnap = lastHotSnapShot {
            docRef = docRef.start(afterDocument: lastSnap)
        }
        
        self.hotListener = docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.lastHotSnapShot = querySnapshot?.documents.last
            
            // map documents to PostItem
            let hotPosts = documents.map { queryDocumentSnapshot -> PostItem in
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
            self.hotPosts.append(contentsOf: hotPosts)
            // update postPlayers accordingly
            self.hotPostPlayers = self.hotPosts.compactMap { post in
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
