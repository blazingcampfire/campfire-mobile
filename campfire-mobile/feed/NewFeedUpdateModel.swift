//
//  NewFeedUpdateModel.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/13/23.
//

import SwiftUI
import Firebase

class NewFeedUpdateModel: ObservableObject {
    
    func increasePostLikes(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing post likes")
            }
        }
    }

    func decreasePostLikes(postId: String) {
        let docRef = ndPosts.document(postId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing post likes")
            }
        }
    }

    func increasePosterUserLikes(posterId: String) {
        let docRef = yaleProfiles.document(posterId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success increasing users likes")
            }
        }
    }

    func decreasePosterUserLikes(posterId: String) {
        let docRef = yaleProfiles.document(posterId)
        docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("Error updating document \(error)")
            } else {
                print("Success decreasing users likes")
            }
        }
        
    }
    
}
