//
//  LikeButtonView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/11/23.
//

import SwiftUI
import Firebase


struct LikeButtonView: View {
    @StateObject var likeModel: LikeButtonModel
    
    var body: some View {
        Button(action: {
            likeModel.toggleLike()
        }) {
            Image(likeModel.isLiked ? "eaten" : "noteaten")
                .padding(.leading, -15)
        }
    }
}

class LikeButtonModel: ObservableObject {
    @Published var isLiked: Bool
    var posterId: String
    var postId: String
    
    static var likeStatusCache: [String: Bool] = [:]
    
    init(posterId: String, postId: String) {
        self.posterId = posterId
        self.postId = postId
        self.isLiked = LikeButtonModel.likeStatusCache[postId, default: false]
    }

    func toggleLike() {
        isLiked.toggle()
        LikeButtonModel.likeStatusCache[postId] = isLiked
        if isLiked {
            increasePostLikes(postId: postId)
            print("increase posts likes")
            increasePosterUserLikes(posterId: posterId)
            print("increased user's like from comments")
        } else {
            decreasePostLikes(postId: postId)
            print("decreased posts likes")
            decreasePosterUserLikes(posterId: posterId)
            print("decreased users like from comments")
        }
    }
}

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
