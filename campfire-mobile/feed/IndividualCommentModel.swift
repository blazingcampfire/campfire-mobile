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
    
    init(commentItem: Comment, postId: String) {
        self.commentItem = commentItem
        self.postId = postId
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
           let commentDocRef = ndPosts.document(postId).collection("comments").document(commentItem.id)
           let userDocRef = yaleProfiles.document(commentItem.posterId)
           
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
    
    func increaseCommentLikes() {
        let docRef = ndPosts.document(postId).collection("comments").document(commentItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing comment likes")
                DispatchQueue.main.async {
                    self.commentItem.numLikes += 1
                }
            }
        }
    }

    func decreaseCommentLikes() {
        let docRef = ndPosts.document(postId).collection("comments").document(commentItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing comment likes")
                DispatchQueue.main.async {
                    self.commentItem.numLikes -= 1
                }
            }
        }
    }
    
    func increaseUserLikesCom() {
        let docRef = yaleProfiles.document(commentItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing users likes from comment")
            }
        }
    }

    func decreaseUserLikesCom() {
        let docRef = yaleProfiles.document(commentItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing users likes from comment")
            }
        }
    }
}

class IndividualReply: ObservableObject {
    @Published var replyItem: Reply
    @Published var postId: String
    @Published var commentId: String
    @Published var isLiked: Bool = false

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

    init(replyItem: Reply, postId: String, commentId: String) {
        self.replyItem = replyItem
        self.postId = postId
        self.commentId = commentId
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
           let replyDocRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").document(replyItem.id)
           let userDocRef = yaleProfiles.document(replyItem.posterId)
           
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
    
    
    
    
    func increaseReplyLikes() {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").document(replyItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing reply likes")
                DispatchQueue.main.async {
                    self.replyItem.numLikes += 1
                }
            }
        }
    }

    func decreaseReplyLikes() {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").document(replyItem.id)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing reply likes")
                DispatchQueue.main.async {
                    self.replyItem.numLikes -= 1
                }
            }
        }
    }
    
    func increaseUserLikesReply() {
        let docRef = yaleProfiles.document(replyItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing users likes from reply")
            }
        }
    }

    func decreaseUserLikesReply() {
        let docRef = yaleProfiles.document(replyItem.posterId)
        docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing users likes from reply")
            }
        }
    }

}


