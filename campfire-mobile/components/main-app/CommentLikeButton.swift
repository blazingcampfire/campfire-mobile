////
////  CommentLikeButton.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 8/11/23.
////
//
//import SwiftUI
//import Firebase
//
//struct CommentButtonLikeView: View {
//    @ObservedObject var comLikeModel: comLikeButtonModel
//
//    var body: some View {
//        Button(action: comLikeModel.toggleLike) {
//            Image(comLikeModel.isLiked ? "eaten" : "noteaten")
//                .resizable()
//                .frame(width: 75, height: 90)
//                .aspectRatio(contentMode: .fit)
//                .offset(x: -4)
//        }
//    }
//}
//
//class comLikeButtonModel: ObservableObject {
//    @Published var isLiked = false
//    var posterId: String
//    var postId: String
//    var comId: String
//
//    init(posterId: String, postId: String, comId: String) {
//        self.posterId = posterId
//        self.postId = postId
//        self.comId = comId
//    }
//
//    func toggleLike() {
//        isLiked.toggle()
//        if isLiked {
//            increaseCommentLikes(postId: postId, comId: comId)
//            print("increase comment likes")
//            increasePosterUserLikes(posterUserId: posterId)
//            print("increased user's like from comments")
//        } else {
//            decreaseCommentLikes(postId: postId, comId: comId)
//            print("decreased comment likes")
//            decreasePosterUserLikes(posterUserId: posterId)
//            print("decreased users like from comments")
//        }
//    }
//}
//
//
//func increaseCommentLikes(postId: String, comId: String) {
//    let docRef = ndPosts.document(postId).collection("comments").document(comId)
//    docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
//        if let error = error {
//            print("Error updating document \(error)")
//        } else {
//            print("Success increasing comment likes")
//        }
//    }
//}
//
//func decreaseCommentLikes(postId: String, comId: String) {
//    let docRef = ndPosts.document(postId).collection("comments").document(comId)
//    docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
//        if let error = error {
//            print("Error updating document \(error)")
//        } else {
//            print("Success decreasing comment likes")
//        }
//    }
//}
