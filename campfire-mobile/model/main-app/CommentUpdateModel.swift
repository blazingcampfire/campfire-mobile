//
//  CommentUpdateModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/10/23.
//

import SwiftUI
import Firebase

class CommentUpdateModel: ObservableObject {
    @Published var commentLikes = [CommentLike]()
    @Published var postId: String? = nil {
        didSet {
        }
    }
    @Published var comId: String? = nil {
        didSet {
            listenForCommentLikes()
        }
    }
    @Published var currentUser: CurrentUserModel
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func listenForCommentLikes() {
        guard let postId = postId else {
            return
        }
        guard let comId = comId else {return}
        
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("likes")
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.commentLikes = documents.map{ queryDocumentSnapshot -> CommentLike in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                return CommentLike(id: id, date: date)
            }
            
        }
    }
    
    func createLikeDocument(postId: String, comId: String ,userId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("likes").document(userId)
        let now = Timestamp(date: Date())
        let likeData: [String: Any] = [
            "id": userId,
            "date": now
        ]
        docRef.setData(likeData) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation com like doc")
            }
        }
    }
    
    func deleteLikeDocument(postId: String, comId: String ,userId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("likes").document(userId)
        docRef.delete { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success delete com like doc")
            }
        }
    }
    
    
}
