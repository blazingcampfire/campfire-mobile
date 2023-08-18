////
////  ReplyLikeButton.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 8/12/23.
////
//
//import SwiftUI
//import Firebase
//
//
//struct ReplyButtonLikeView: View {
//    @ObservedObject var replyLikeModel: replyLikeButtonModel
//
//    var body: some View {
//        Button(action: replyLikeModel.toggleLike) {
//            Image(replyLikeModel.isLiked ? "eaten" : "noteaten")
//                .resizable()
//                .frame(width: 75, height: 90)
//                .aspectRatio(contentMode: .fill)
//                .offset(x: -2)
//        }
//    }
//}
//
//class replyLikeButtonModel: ObservableObject {
//    @Published var isLiked = false
//    var posterId: String
//    var postId: String
//    var comId: String
//    var replyId: String
//
//    init(posterId: String, postId: String, comId: String, replyId: String) {
//        self.posterId = posterId
//        self.postId = postId
//        self.comId = comId
//        self.replyId = replyId
//    }
//
//    func toggleLike() {
//        isLiked.toggle()
//        if isLiked {
//            increaseReplyLikes(postId: postId, comId: comId, replyId: replyId)
//            print("increase reply likes")
//            increasePosterUserLikes(posterUserId: posterId)
//            print("increased user's like from reply")
//        } else {
//            decreaseReplyLikes(postId: postId, comId: comId, replyId: replyId)
//            print("decreased reply likes")
//            decreasePosterUserLikes(posterUserId: posterId)
//            print("decreased users like from reply")
//        }
//    }
//}
//
//
//func increaseReplyLikes(postId: String, comId: String, replyId: String) {
//    let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("replies").document(replyId)
//    docRef.updateData(["numLikes": FieldValue.increment(Int64(1))]) { error in
//        if let error = error {
//            print("Error updating document \(error)")
//        } else {
//            print("Success increasing reply likes")
//        }
//    }
//}
//
//func decreaseReplyLikes(postId: String, comId: String, replyId: String) {
//    let docRef = ndPosts.document(postId).collection("comments").document(comId).collection("replies").document(replyId)
//    docRef.updateData(["numLikes": FieldValue.increment(Int64(-1))]) { error in
//        if let error = error {
//            print("Error updating document \(error)")
//        } else {
//            print("Success decreasing reply likes")
//        }
//    }
//}
