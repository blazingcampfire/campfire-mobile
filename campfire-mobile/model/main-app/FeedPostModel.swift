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
    @Published var postPlayers = [PostPlayer?]()
    private var listener: ListenerRegistration?
    
    init() {
       self.listenForPosts()
    }
    
    deinit {
        listener?.remove()
    }
        
    func listenForPosts() {
        let docRef = ndPosts
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            // map documents to PostItem
            self.posts = documents.map { queryDocumentSnapshot -> PostItem in
                let data = queryDocumentSnapshot.data()
                // extract properties from data and construct PostItem
                let id = data["id"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let caption = data["caption"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let numLikes = data["numLikes"] as? Int ?? 0
                let location = data["location"] as? String ?? ""
                let postType = data["postType"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, numLikes: numLikes, location: location, postType: postType, date: date)
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
    
    func increaseLikeCount(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func decreaseLikeCount(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
                }
            }
        }
    
    
}
