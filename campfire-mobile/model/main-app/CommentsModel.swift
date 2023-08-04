//
//  CommentsModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/30/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class CommentsModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var repliesByComment = [String: [Reply]]()
    @Published var replies = [Reply]()
    @Published var isLoading: Bool = false
    private var isCommentsLoaded = false
    @Published var postId: String? = nil {
        didSet {
            listenForComments()
        }
    }
    @Published var commentId: String? = nil {
        didSet {
            listenForReplies()
        }
    }
    
    func createComment(postId: String, commenttext: String ,completion: @escaping () -> Void) {
        let docRef = ndPosts.document(postId).collection("comments").document()
        let commentData: [String: Any] = [
            "id": docRef.documentID,
            "username": "bizzle",
            "profilepic": "",
            "comment": commenttext,
            "numLikes": 0,
            "date": "",
        ]
        docRef.setData(commentData) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation")
                completion()
            }
        }
    }
    
    func createReply(postId: String, commentId: String, replytext: String ,completion: @escaping () -> Void) {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").document()
        let replyData: [String: Any] = [
            "id": docRef.documentID,
            "username": "bizzle",
            "profilepic": "",
            "reply": replytext,
            "numLikes": 0,
            "date": "10m",
        ]
        docRef.setData(replyData) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation")
                completion()
            }
        }
    }
    
    func listenForComments() {
        guard let postId = postId else {
            return
        }
        let docRef = ndPosts.document(postId).collection("comments")
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.comments = documents.map { queryDocumentSnapshot -> Comment in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let comment = data["comment"] as? String ?? ""
                let numLikes = data["numLikes"] as? Int ?? 0
                let date = data["date"] as? String ?? ""
                return Comment(id: id, profilepic: profilepic, username: username, comment: comment, numLikes: numLikes, date: date)
            }
        }
    }
    
    func listenForReplies() {
        guard let postId = postId else {
            return
        }
        guard let commentId = commentId else {
            return
        }
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies")
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.replies = documents.map { queryDocumentSnapshot -> Reply in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let reply = data["reply"] as? String ?? ""
                let numLikes = data["numLikes"] as? Int ?? 0
                let date = data["date"] as? String ?? ""
                return Reply(id: id, profilepic: profilepic, username: username, reply: reply, numLikes: numLikes, date: date)
            }
        }
    }
    
    
    
    func updateCommentLikeCount(postId: String, commentId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
           print("Error updating document: \(error)")
           } else {
           print("Document successfully updated!")
           }
        }
   }
    func updateReplyLikeCount(postId: String, commentId: String, replyId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").document(replyId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
           print("Error updating document: \(error)")
           } else {
           print("Document successfully updated!")
           }
        }
    }

}
