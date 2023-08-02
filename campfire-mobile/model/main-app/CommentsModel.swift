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
    @Published var commenttext = ""
    @Published var replytext = ""
    @Published var repliesByComment = [String: [Reply]]()
    @Published var isLoading: Bool = false
    
    func createComment(postId: String, completion: @escaping () -> Void) {
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
    func createReply(commentId: String, postId: String, completion: @escaping () -> Void) {
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
    
    func getComments(postId: String) {
        let docRef = ndPosts.document(postId).collection("comments")
        docRef.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.comments = snapshot.documents.map { doc in
                            return Comment(id: doc["id"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", username: doc["username"] as? String ?? "", comment: doc["comment"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, date: doc["date"] as? String ?? "")
                        }
                    }
                }
            }
        }
    }
    
    func getReplies(postId: String, commentId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies")
        docRef.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.repliesByComment[commentId] = snapshot.documents.map { doc in
                            return Reply(id: doc["id"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", username: doc["username"] as? String ?? "", reply: doc["reply"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, date: doc["date"] as? String ?? "")
                        }
                        
                    }
                }
            }
        }
    }

}
