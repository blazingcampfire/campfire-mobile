//
//  IndividualCommentModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/15/23.
//

import SwiftUI
import Firebase


class IndividualComment: ObservableObject {
    @Published var commentItem: Comment
    @Published var postId: String
    @Published var isLiked: Bool = false
    @Published var currentUser: CurrentUserModel
    
    var profilepic: String {
        return commentItem.profilepic
    }
    
    var username: String {
        return commentItem.username
    }
    
    var comment: String {
        return commentItem.comment
    }
    
    var date: Timestamp {
        return commentItem.date
    }
    
    var numLikes: Int {
        return commentItem.numLikes
    }
    
    var comId: String {
        return commentItem.id
    }
    
    init(commentItem: Comment, postId: String, currentUser: CurrentUserModel) {
        self.commentItem = commentItem
        self.postId = postId
        self.currentUser = currentUser
        self.isLiked = commentItem.usersWhoLiked.contains(currentUser.profile.userID)
    }
    
    
    func toggleLikeStatus() {
        commentItem.usersWhoLiked.removeAll(where: {$0 == ""})
        
        if let index = commentItem.usersWhoLiked.firstIndex(of: currentUser.profile.userID) {
            isLiked = false
            commentItem.usersWhoLiked.remove(at: index)
            modifyLikes(increment: -1)
        } else {
            isLiked = true
            commentItem.usersWhoLiked.append(currentUser.profile.userID)
            modifyLikes(increment: 1)
        }
        updateUsersWhoLikedCom()
    }
    
    func modifyLikes(increment: Int64) {
        let commentDocRef = currentUser.postsRef.document(postId).collection("comments").document(commentItem.id)
        let userDocRef = currentUser.profileRef.document(commentItem.posterId)
           
           // Run a transaction
           db.runTransaction({ (transaction, errorPointer) -> Any? in
               transaction.updateData(["numLikes": FieldValue.increment(increment)], forDocument: commentDocRef)
               transaction.updateData(["smores": FieldValue.increment(increment)], forDocument: userDocRef)
               return nil
           }) { (object, error) in
               if let error = error {
                   print("Transaction failed: \(error)")
               } else {
                   print("Transaction successfully committed!")
                   DispatchQueue.main.async {
                       self.commentItem.numLikes += Int(increment)
                       // Update user's like count in the UI, if necessary
                   }
               }
           }
       }
    
    func updateUsersWhoLikedCom() {
        let docRef = currentUser.postsRef.document(postId).collection("comments").document(commentItem.id)
        docRef.updateData(["usersWhoLiked": commentItem.usersWhoLiked]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success updating comment usersWhoLiked array")
            }
        }
    }
    
    
}

class IndividualReply: ObservableObject {
    @Published var replyItem: Reply
    @Published var postId: String
    @Published var commentId: String
    @Published var isLiked: Bool = false
    @Published var currentUser: CurrentUserModel

    var profilepic: String {
        return replyItem.profilepic
    }

    var username: String {
        return replyItem.username
    }

    var reply: String {
        return replyItem.reply
    }

    var date: Timestamp {
        return replyItem.date
    }

    var numLikes: Int {
        return replyItem.numLikes
    }

    init(replyItem: Reply, postId: String, commentId: String, currentUser: CurrentUserModel) {
        self.replyItem = replyItem
        self.postId = postId
        self.commentId = commentId
        self.currentUser = currentUser
        self.isLiked = replyItem.usersWhoLiked.contains(currentUser.profile.userID)
    }

    func toggleLikeStatus() {
        replyItem.usersWhoLiked.removeAll(where: {$0 == ""})
        
        if let index = replyItem.usersWhoLiked.firstIndex(of: currentUser.profile.userID) {
            isLiked = false
            replyItem.usersWhoLiked.remove(at: index)
            modifyLikes(increment: -1)
        } else {
            isLiked = true
            replyItem.usersWhoLiked.append(currentUser.profile.userID)
            modifyLikes(increment: 1)
        }
        updateUsersWhoLikedReply()
    }
    
    func modifyLikes(increment: Int64) {
        let replyDocRef = currentUser.postsRef.document(postId).collection("comments").document(commentId).collection("replies").document(replyItem.id)
        let userDocRef = currentUser.profileRef.document(replyItem.posterId)
           
           // Run a transaction
           db.runTransaction({ (transaction, errorPointer) -> Any? in
               transaction.updateData(["numLikes": FieldValue.increment(increment)], forDocument: replyDocRef)
               transaction.updateData(["smores": FieldValue.increment(increment)], forDocument: userDocRef)
               return nil
           }) { (object, error) in
               if let error = error {
                   print("Transaction failed: \(error)")
               } else {
                   print("Transaction successfully committed!")
                   DispatchQueue.main.async {
                       self.replyItem.numLikes += Int(increment)
                   }
               }
           }
       }
    
    func updateUsersWhoLikedReply() {
        let docRef = currentUser.postsRef.document(postId).collection("comments").document(commentId).collection("replies").document(replyItem.id)
        docRef.updateData(["usersWhoLiked": replyItem.usersWhoLiked]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success updating reply usersWhoLiked array")
            }
        }
    }

}


