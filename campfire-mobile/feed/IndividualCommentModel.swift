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
    }
    
    func toggleLikeStatus() {
        isLiked.toggle()
        if isLiked {
         modifyLikes(increment: 1)
        } else {
         modifyLikes(increment: -1)
        }
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
    }

    func toggleLikeStatus() {
        isLiked.toggle()
        if isLiked {
        modifyLikes(increment: 1)
        } else {
         modifyLikes(increment: -1)
        }
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

}


