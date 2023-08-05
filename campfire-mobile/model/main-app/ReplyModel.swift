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

//class ReplyModel: ObservableObject {
//
//    @Published var replies = [Reply]()
////    @Published var postId: String? = nil {
////        didSet {
////            getComments()
////        }
////    }
//
//
//    //This downloads the document from firebase/decodes the document into the object
//    func getReplies(postId: String, commentId: String) {
//        let docRef = ndPosts.document(postId).collection("comments").document(commentId).collection("replies")
//        docRef.getDocuments { snapshot, error in
//            if error == nil {
//                if let snapshot = snapshot {
//                    DispatchQueue.main.async {
//                        self.replies = snapshot.documents.map { doc in
//                            return Reply(id: doc["id"] as? String ?? "", profilepic: doc["profilepic"] as? String ?? "", username: doc["username"] as? String ?? "", reply: doc["reply"] as? String ?? "", numLikes: doc["numLikes"] as? Int ?? 0, date: doc["date"] as? String ?? "")
//                        }
//                        print(self.replies)
//                    }
//                } else {
//                    print(error!)
//                }
//            } else {
//                print(error!)
//            }
//        }
//            }
//        }
//
    
    

