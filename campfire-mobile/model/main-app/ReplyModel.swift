//
//  ReplyModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/31/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class ReplyModel: ObservableObject {
    
    @Published var replies = [Reply]()
    @Published var replytext = ""
    
    //Think of these functions like an upload/download
    
    //This uploads the object to firebase/creates the document
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
    
    //This downloads the document from firebase/decodes the document into the object
    func getReplies(postId: String, commentId: String) {
        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies")
        docRef.getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.replies = snapshot.documents.map { doc in
                            return Reply(id: doc["id"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", username: doc["username"] as? String ?? "", reply: doc["reply"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, date: doc["date"] as? String ?? "")
                        }
                        print(self.replies)
                    }
                } else {
                    print(error!)
                }
            } else {
                print(error!)
            }
        }
            }
        }
    
    
    

