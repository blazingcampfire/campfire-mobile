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
    
    func listenForPosts() {
        print("listener went off 1")
        let docRef = ndPosts
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.feedPosts = documents.map { queryDocumentSnapshot -> PostItem in
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
                let numLikes = data["numLikes"] as? Int ?? 0
                return PostItem(id: id, username: username, name: name, caption: caption, profilepic: profilepic, url: url, location: location, postType: postType, date: date, posterId: posterId, numLikes: numLikes)
            }
            print(self.feedPosts)
            DispatchQueue.main.async {
                print("listener went off 3")
                self.objectWillChange.send()
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


