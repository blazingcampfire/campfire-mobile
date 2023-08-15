//
//  IndividualPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/14/23.
//

import SwiftUI
import Firebase

class IndividualPost: ObservableObject {
    @Published var postItem: PostItem
    @Published var isLiked: Bool = false
    
    var numLikes: Int {
        return postItem.numLikes
    }
    
    var username: String {
        return postItem.username
    }
    
    var profilepic: String {
        return postItem.profilepic
    }
    
    var caption: String {
        return postItem.caption
    }
    
    var location: String {
        return postItem.location
    }
    
    var content: String {
        return postItem.url
    }
    
    var postType: String {
        return postItem.postType
    }
    
    
    init(postItem: PostItem) {
        self.postItem = postItem
    }
    
    func toggleLikeStatus() {
        isLiked.toggle()
        if isLiked {
            increasePostLikes()
        } else {
            decreasePostLikes()
        }
    }
    
    func increasePostLikes() {
        let docRef = ndPosts.document(postItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing post likes")
                DispatchQueue.main.async {
                    self.postItem.numLikes += 1
                }
            }
        }
    }

    func decreasePostLikes() {
        let docRef = ndPosts.document(postItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing post likes")
                DispatchQueue.main.async {
                    self.postItem.numLikes -= 1
                }
            }
        }
    }
    
    func increasePosterUserLikes(posterId: String) {
        let docRef = yaleProfiles.document(posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing users likes")
            }
        }
    }

    func decreasePosterUserLikes(posterId: String) {
        let docRef = yaleProfiles.document(posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing users likes")
            }
        }
        
    }
    
    
}
