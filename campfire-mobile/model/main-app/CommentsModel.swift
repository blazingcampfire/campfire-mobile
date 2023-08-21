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
import Combine

class CommentsModel: ObservableObject {
    @Published var comments = [Comment]()
    @Published var repliesByComment: [String: [Reply]] = [:]
    @Published var currentUser: CurrentUserModel
    @Published var postId: String
    @Published var commentText: String = ""
    @Published var replyText: String = ""
    @Published var getRepliesFor: String? = nil {
        didSet {
            listenForReplies()
        }
    }
    
    var commentListener: ListenerRegistration?
    var replyListener: ListenerRegistration?
    
    
    init(currentUser: CurrentUserModel, postId: String) {
        self.currentUser = currentUser
        self.postId = postId
        listenForComments()
    }
    
    
    //Create UserId field on each comment 
    func createComment() {
        let docRef = currentUser.postsRef.document(postId).collection("comments").document()
        let now = Timestamp(date: Date())
        let commentData: [String: Any] = [
            "id": docRef.documentID,
            "username": currentUser.profile.username,
            "profilepic": currentUser.profile.profilePicURL,
            "comment": commentText,
            "date": now,
            "posterId": currentUser.profile.userID,
            "numLikes": 0,
            "usersWhoLiked": [""]
        ]
        docRef.setData(commentData) { error in
            if let error = error {
                return
            } else {
                self.commentText = ""
            }
        }
    }
    
    func createReply(comId: String) {
        let docRef = currentUser.postsRef.document(postId).collection("comments").document(comId).collection("replies").document()
        let now = Timestamp(date: Date())
        let replyData: [String: Any] = [
            "id": docRef.documentID,
            "username": currentUser.profile.username,
            "profilepic": currentUser.profile.profilePicURL,
            "reply": replyText,
            "date": now,
            "posterId": currentUser.profile.userID,
            "numLikes": 0,
            "usersWhoLiked": [""]
        ]
        docRef.setData(replyData) { error in
            if let error = error {
               return
            } else {
                self.replyText = ""
            }
        }
    }
        
    
    func listenForComments() {
        let docRef = currentUser.postsRef.document(postId).collection("comments").order(by: "date", descending: false)
        commentListener = docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
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
                let numLikes = data["numLikes"] as? Int ?? 0
                let usersWhoLiked = data["usersWhoLiked"] as? [String] ?? [""]
                return Comment(id: id, profilepic: profilepic, username: username, comment: comment, date: date, posterId: posterId, numLikes: numLikes, usersWhoLiked: usersWhoLiked)
            } 

            }
        }
    
    func listenForReplies() {
        guard let getRepliesFor = getRepliesFor else {
            return
        }
        let docRef = currentUser.postsRef.document(postId).collection("comments").document(getRepliesFor).collection("replies").order(by: "date", descending: false)
        replyListener = docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            self.repliesByComment[getRepliesFor] = documents.map { queryDocumentSnapshot -> Reply in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let profilepic = data["profilepic"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let reply = data["reply"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                let posterId = data["posterId"] as? String ?? ""
                let numLikes = data["numLikes"] as? Int ?? 0
                let usersWhoLiked = data["usersWhoLiked"] as? [String] ?? [""]
                return Reply(id: id, profilepic: profilepic, username: username, reply: reply, date: date, posterId: posterId, numLikes: numLikes, usersWhoLiked: usersWhoLiked)
            }
        }
    }
    
    
    
}
