//
//  NewFeedModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/13/23.
//

import SwiftUI
import Firebase

class NewFeedModel: ObservableObject {
@Published var feedPosts: [PostItem] = []
@Published var likedPosts: [String: Bool] = [:]
    
    func listenForPosts() {
        print("listener went off 1")
        let docRef = ndPosts
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { difference in
                // Create PostItem from Firestore Document
                let data = difference.document.data()
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
                let numLikes = data["numLikes"] as? Int ?? 0
                let postItem = PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes)
                
                if (difference.type == .added) {
                    print("New post: \(data)")
                    DispatchQueue.main.async {
                        self.feedPosts.append(postItem)
                        self.objectWillChange.send()
                    }
                } else if (difference.type == .modified) {
                    print("Updated post: \(data)")
                    if let index = self.feedPosts.firstIndex(where: { $0.id == postItem.id }) {
                        DispatchQueue.main.async {
                            self.feedPosts[index] = postItem
                            self.objectWillChange.send()
                        }
                    }
                } else if (difference.type == .removed) {
                    print("Removed post: \(data)")
                    if let index = self.feedPosts.firstIndex(where: { $0.id == postItem.id }) {
                        DispatchQueue.main.async {
                            self.feedPosts.remove(at: index)
                            self.objectWillChange.send()
                        }
                    }
                }
            }
        }
    }
    
    func increasePostLikes(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing post likes")
            }
        }
    }

    func decreasePostLikes(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing post likes")
            }
        }
    }
    
    
}


