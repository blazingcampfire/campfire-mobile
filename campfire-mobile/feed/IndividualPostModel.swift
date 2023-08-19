//
//  IndividualPostModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/14/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class IndividualPost: ObservableObject {
    @Published var postItem: PostItem
    @Published var isLiked: Bool = false
    @Published var currentUser: CurrentUserModel
    
    var numLikes: Int {
        return postItem.numLikes
    }
    var comNum: Int {
        return postItem.comNum
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
    
    var id: String {
        return postItem.id
    }
    
    var posterId: String {
        return postItem.posterId
    }
    
    init(postItem: PostItem, currentUser: CurrentUserModel) {
        self.postItem = postItem
        self.currentUser = currentUser
    }
    
    private var listener: ListenerRegistration?
    
    func toggleLikeStatus() {
        isLiked.toggle()
        if isLiked {
            increasePostLikes()
            increasePostScore()
            increaseUserLikesPost()
        } else {
            decreasePostLikes()
            decreasePostScore()
            decreaseUserLikesPost()
        }
    }
    
    func increaseComNum() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["comNum": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing comNum")
                DispatchQueue.main.async {
                    self.postItem.comNum += 1
                }
            }
        }
    }
    
    func increasePostScore() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["score": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing post score")
            }
        }
    }
    
    func decreasePostScore() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["score": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing post score")
            }
        }
    }
    
    
    
    
    func increasePostLikes() {
        let docRef = currentUser.postsRef.document(postItem.id)
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
        let docRef = currentUser.postsRef.document(postItem.id)
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
    
    func increaseUserLikesPost() {
        let docRef = currentUser.profileRef.document(postItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing users likes from post")
            }
        }
    }

    func decreaseUserLikesPost() {
        let docRef = currentUser.profileRef.document(postItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing users likes from post")
            }
        }
    }
    
    func deletePostDocument() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.delete() { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success deleting post document")
            }
        }
    }
    
    func reportPost(issue: String) {
        let docRef = ndReports.document(postItem.id)
        docRef.setData([
            "postID": postItem.id,
            "userID": postItem.posterId,
            "issue": issue,
            "postType": postItem.postType
        ])
        print(postItem.id, postItem.posterId, issue, postItem.postType)
    }
    
    
    
    
}
