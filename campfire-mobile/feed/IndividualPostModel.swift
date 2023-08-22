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
    
    var algorithm: Double {
        return Double(postItem.numLikes + (postItem.comNum * Int(1.5)))
    }
    
    var decreaseAlgo: Double {
        return Double((postItem.numLikes + (postItem.comNum * Int(1.5))) * (-1))
    }
    
    var usersWhoLiked: [String] {
        return postItem.usersWhoLiked
    }
    
    
    init(postItem: PostItem, currentUser: CurrentUserModel) {
        self.postItem = postItem
        self.currentUser = currentUser
        self.isLiked = postItem.usersWhoLiked.contains(currentUser.profile.userID)
    }
    private var listener: ListenerRegistration?
    
    
    func toggleLikeStatus() {
        
        postItem.usersWhoLiked.removeAll(where: { $0 == "" })
        // If user has already liked the post
        if let index = postItem.usersWhoLiked.firstIndex(of: currentUser.profile.userID) {
            isLiked = false
            postItem.usersWhoLiked.remove(at: index)  // Remove user ID from the list
            if postItem.numLikes > 0 {
                decreasePostLikes()
                increasePostScore()
                decreaseUserLikesPost()
            }
        } else { // If user hasn't liked the post yet
            isLiked = true
            postItem.usersWhoLiked.append(currentUser.profile.userID)  // Append user ID to the list
            
            increasePostLikes()
            increasePostScore()
            increaseUserLikesPost()
        }
        
        updateUsersWhoLiked()
    }
    
    func updateUsersWhoLiked() {
    let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["usersWhoLiked": postItem.usersWhoLiked]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success updating usersWhoLiked array")
            }
        }
    }
    
    
    
    
    
    func increaseComNum() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["comNum": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                return
            } else {
                DispatchQueue.main.async {
                    self.postItem.comNum += 1
                }
            }
        }
    }
    
    func increasePostScore() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["score": FieldValue.increment(Double(algorithm))]) { error in
            if let error = error {
              return
            }
        }
    }
    
    func decreasePostScore() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["score": FieldValue.increment(Double(algorithm))]) { error in
            if let error = error {
                return
            }
        }
    }
    
    
    
    func increasePostLikes() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                return
            } else {
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
                return
            } else {
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
                return
            }
        }
    }

    func decreaseUserLikesPost() {
        let docRef = currentUser.profileRef.document(postItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                return
            }
        }
    }
    
    func deletePostDocument() {
        let docRef = currentUser.postsRef.document(postItem.id)
        docRef.delete() { error in
            if let error = error {
                return
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
    }
    
    
    
    
}
