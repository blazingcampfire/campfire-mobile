//
//  FeedPostUpdateModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/4/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import AVKit

// This is for updating things on the Feed because it redraws the State

class FeedPostUpdateModel: ObservableObject {
    @Published var likes = [Like]()
    @Published var postId: String? = nil {
        didSet {
            listenForPostLikes()
        }
    }
    @Published var currentUser: CurrentUserModel
    
    init(currentUser: CurrentUserModel) {
        self.currentUser = currentUser
    }
    
    func listenForPostLikes() {
        guard let postId = postId else {
            return
        }
        let docRef = ndPosts.document(postId).collection("likes")
        docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.likes = documents.map{ queryDocumentSnapshot -> Like in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let date = data["date"] as? Timestamp ?? Timestamp()
                return Like(id: id, date: date)
            }
            
        }
    }
    
    func createLikeDocument(postId: String, userId: String) {
        let docRef = ndPosts.document(postId).collection("likes").document(userId)
        let now = Timestamp(date: Date())
        let likeData: [String: Any] = [
            "id": userId,
            "date": now
        ]
        docRef.setData(likeData) { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success creation like doc")
            }
        }
    }
    
    func deleteLikeDocument(postId: String, userId: String) {
        let docRef = ndPosts.document(postId).collection("likes").document(userId)
        docRef.delete { error in
            if let error = error {
                print("Error writing document \(error)")
            } else {
                print("success delete like doc")
            }
        }
    }
    
    func increasePosterUserLikes(posterUserId: String) {
        let docRef = yaleProfiles.document(posterUserId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // The document exists, proceed to update
                docRef.updateData(["smores": FieldValue.increment(Int64(1))]) { error in
                    if let error = error {
                        print("Error updating document \(error)")
                    } else {
                        print("Success incrementing likes")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
        
    func decreasePosterUserLikes(posterUserId: String) {
        let docRef = yaleProfiles.document(posterUserId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.updateData(["smores": FieldValue.increment(Int64(-1))]) { error in
                    if let error = error {
                        print("Error updating document \(error)")
                    } else {
                        print("Success decreasing likes")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    }
    


