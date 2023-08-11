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
import Firebase

class CommentsModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var repliesByComment = [String: [Reply]]()
    @Published var replies = [Reply]()
    @Published var currentUser: CurrentUserModel
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
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    //Create UserId field on each comment 
    func createComment(postId: String, commenttext: String ,completion: @escaping () -> Void) {
        let docRef = ndPosts.document(postId).collection("comments").document()
        let now = Timestamp(date: Date())
        let commentData: [String: Any] = [
            "id": docRef.documentID,
            "username": currentUser.profile.username,
            "profilepic": currentUser.profile.profilePicURL,
            "comment": commenttext,
            "date": now,
            "posterId": currentUser.profile.userID
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
        let now = Timestamp(date: Date())
        let replyData: [String: Any] = [
            "id": docRef.documentID,
            "username": currentUser.profile.username,
            "profilepic": currentUser.profile.profilePicURL,
            "reply": replytext,
            "date": now,
            "posterId": currentUser.profile.userID
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

        let docRef = ndPosts.document(postId).collection("comments").order(by: "date", descending: false)

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
                let date = data["date"] as? Timestamp ?? Timestamp()
                let posterId = data["posterId"] as? String ?? ""
                return Comment(id: id, profilepic: profilepic, username: username, comment: comment, date: date, posterId: posterId)
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
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies").order(by: "date", descending: false)
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.repliesByComment[commentId] = documents.map { queryDocumentSnapshot -> Reply in
                let data = queryDocumentSnapshot.data()
                
                let id = data["id"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let reply = data["reply"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                let posterId = data["posterId"] as? String ?? ""
                return Reply(id: id, profilepic: profilepic, username: username, reply: reply, date: date, posterId: posterId)
            }
        }
    }
    

}
