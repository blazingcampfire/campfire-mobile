//
//  CommentsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/8/23.
//

import SwiftUI
import UIKit
import Kingfisher


struct CommentsPage: View {
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var commentModel: CommentsModel
    @State private var replyingToCommentId: String?
    @State private var replyingToUserId: String?
    @EnvironmentObject var currentUser: CurrentUserModel
    @ObservedObject var post: IndividualPost
    @ObservedObject var newFeedModel: NewFeedModel

    var body: some View {
        NavigationView {
            VStack {
                CommentsList(commentModel: commentModel, replyingToComId: $replyingToCommentId, replyingToUserId: $replyingToUserId)
                Divider()
                VStack {
                    HStack {
                        if replyingToUserId != nil {
                            
                            KFImage(URL(string: currentUser.profile.profilePicURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack {
                                Text("Replying to: @\(replyingToUserId!)")
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                    .padding(.leading, 20)
                                    .foregroundColor(Theme.TextColor)
                                    .padding(.trailing, 50)
                                
                                TextField(
                                    "",
                                    text: replyingToCommentId != nil ? $commentModel.replyText : $commentModel.commentText,
                                    prompt: Text(replyingToCommentId != nil ? "add reply" : "add comment!").font(.custom("LexendDeca-Regular", size: 15))
                                )
                                .onTapGesture {
                                    isEditing = true
                                    newFeedModel.pauseVideos = true
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Theme.Peach))
                            }
                            .padding(.bottom, 15)
                        }  else {
                            
                            KFImage(URL(string: currentUser.profile.profilePicURL))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            TextField(
                                "",
                                text: replyingToCommentId != nil ? $commentModel.replyText : $commentModel.commentText,
                                prompt: Text(replyingToCommentId != nil ? "add reply" : "add comment!").font(.custom("LexendDeca-Regular", size: 15))
                            )
                            .onTapGesture {
                                isEditing = true
                                newFeedModel.pauseVideos = true
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Theme.Peach))
                        }
                        
                        if (isEditing && commentModel.commentText != "") || (isEditing && commentModel.replyText != "") {
                            Button(action: {
                                createContent()
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Theme.Peach)
                            }
                        }
                    }
                    .padding()
                }
            }
            .onTapGesture {
                isEditing = false
                newFeedModel.pauseVideos = false
               UIApplication.shared.dismissKeyboard()
                replyingToCommentId = nil
                replyingToUserId = nil
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Text("Comments")
                            .foregroundColor(Theme.TextColor)
                            .font(.custom("LexendDeca-Bold", size: 23))
                        
                        Text("\(commentModel.comments.count)")
                            .foregroundColor(Theme.TextColor)
                            .font(.custom("LexendDeca-Light", size: 16))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.TextColor)
                            .bold()
                    }
                }
            }
    }
    }
    func createContent() {
        if let replyingId = replyingToCommentId {
            commentModel.createReply(comId: replyingId)
            replyingToCommentId = nil
            replyingToUserId = nil
        } else {
            commentModel.createComment()
            post.increaseComNum()
            post.increasePostScore()
        }
        UIApplication.shared.dismissKeyboard()
    }
}


struct CommentsList: View {
    @ObservedObject var commentModel: CommentsModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @Binding var replyingToComId: String?
    @Binding var replyingToUserId: String?
    var body: some View {
        ScrollView {
            if commentModel.comments.isEmpty {
                VStack(spacing: 10) {
                    Text("be the first to comment!")
                        .foregroundColor(Theme.TextColor)
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Image(systemName: "flame.fill")
                        .foregroundColor(Theme.Peach)
                        .font(.system(size: 35))
                }
                .padding(.top, 170)
            }
            else {
                ForEach(commentModel.comments, id: \.id) { comment in
                    CommentView(commentModel: commentModel, individualComment: IndividualComment(commentItem: comment, postId: commentModel.postId), replyingToComId: $replyingToComId, replyingToUserId: $replyingToUserId)
                }
            }
        }
        .tint(Theme.Peach)
    }
}
      
extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct CommentsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsPage(comments: diffComments)
//    }
//}
