//
//  CommentsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/8/23.
//

import SwiftUI
import UIKit


struct CommentsPage: View {
    var postId: String
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var commentModel = CommentsModel()
    @State private var replyingToCommentId: String?
    @State private var comment: String = ""
    @State private var reply: String = ""
    @State private var replyingToUserId: String?
    @ObservedObject var commentCount: CommentCounter
    
    var body: some View {
        NavigationView {
            VStack {
                CommentsList(commentModel: commentModel, replyingToComId: $replyingToCommentId, replyingToUserId: $replyingToUserId, postID: postId)
                Divider()
                VStack {
                    HStack {

                        if replyingToUserId != nil {
                            
                            Image(info.profilepic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack {
                                Text("Replying to: @\(replyingToUserId!)")
                                    .font(.custom("LexendDeca-Regular", size: 13))
                                    .padding(.leading, 20)
                                    .foregroundColor(Theme.TextColor)
                                    .padding(.trailing, 50)
                                
                                TextField(
                                    "",
                                    text: replyingToCommentId != nil ? $reply : $comment,
                                    prompt: Text(replyingToCommentId != nil ? "add reply" : "add comment!").font(.custom("LexendDeca-Regular", size: 15))
                                )
                                .onTapGesture {
                                    isEditing = true
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(Theme.Peach))
                            }
                            .padding(.bottom, 15)
                        }  else {
                            
                            Image(info.profilepic)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            TextField(
                                "",
                                text: replyingToCommentId != nil ? $reply : $comment,
                                prompt: Text(replyingToCommentId != nil ? "add reply" : "add comment!").font(.custom("LexendDeca-Regular", size: 15))
                            )
                            .onTapGesture {
                                isEditing = true
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .foregroundColor(Theme.Peach))
                        }
                        
                        if (isEditing && comment != "") || (isEditing && reply != "") {
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
        .onAppear {
            commentModel.postId = postId
        }
    }
    func createContent() {
        if let replyingId = replyingToCommentId {
            commentModel.createReply(postId: postId, commentId: replyingId, replytext: reply) {
                reply = ""  // Reset here
                replyingToCommentId = nil
                replyingToUserId = nil
                commentCount.commentcount += 1
            }
        } else {
            commentModel.createComment(postId: postId, commenttext: comment) {
                comment = ""
                commentCount.commentcount += 1
            }
        }
        UIApplication.shared.dismissKeyboard()
    }
}

struct CommentsList: View {
    @ObservedObject var commentModel: CommentsModel
    @Binding var replyingToComId: String?
    @Binding var replyingToUserId: String?
    var postID: String
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
                    CommentView(eachcomment: comment, comId: comment.id, postID: postID, commentsModel: commentModel, replyingToComId: $replyingToComId, replyingToUserId: $replyingToUserId, usernameId: comment.username)
                }
                
            }
        }
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
