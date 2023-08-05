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
    
    func updateLikeCount(postId: String) {
    let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
           print("Error updating document: \(error)")
           } else {
           print("Document successfully updated!")
           }
        }
   }
    
}
