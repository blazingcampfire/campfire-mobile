//
//  ReplyUpdateModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/10/23.
//

import SwiftUI
import Firebase

class ReplyUpdateModel: ObservableObject {
    @Published var replyLikes = [ReplyLike]()
    @Published var postId: String? = nil {
        didSet {
        }
    }
    @Published var comId: String? = nil {
        didSet {
        }
    }
    @Published var replyId: String? = nil {
        didSet {
            listenForReplyLikes()
            print("replyId did set")
        }
    }
    @Published var currentUser: CurrentUserModel
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func listenForReplyLikes() {
        print("now listening for likes")
        guard let postId = postId else {
            return
        }
        guard let comId = comId else {return}
        
        guard let replyId = replyId else {
            return
        }
        print("listening for likes 1")
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("replies").document(replyId).collection("likes")
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.replyLikes = documents.map{ queryDocumentSnapshot -> ReplyLike in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                return ReplyLike(id: id, date: date)
            }
            print("listening for likes 2")
        }
    }
    
    func createLikeDocument(postId: String, comId: String, replyId: String, userId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("replies").document(replyId).collection("likes").document(userId)
        let now = Timestamp(date: Date())
        let likeData: [String: Any] = [
            "id": userId,
            "date": now
        ]
        docRef.setData(likeData) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation reply like doc")
            }
        }
    }
    
    func deleteLikeDocument(postId: String, comId: String , replyId: String, userId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("replies").document(replyId).collection("likes").document(userId)
        docRef.delete { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success delete reply like doc")
            }
        }
    }
}
