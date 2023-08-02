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
    @EnvironmentObject var commentModel: CommentsModel
    @State private var replyingToCommentId: String?
    
    var body: some View {
        NavigationView {
            VStack {
                CommentsList(replyingToCommentId: $replyingToCommentId, postID: postId)
                    .environmentObject(commentModel)
                Divider()
                VStack {
                    HStack {
                        Image(info.profilepic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        if !commentModel.isLoading {
                            TextField(
                                "",
                                text: Binding<String>(
                                    get: {
                                        // Depending on whether you're replying to a comment or not assign the text
                                        if replyingToCommentId != nil {
                                            return commentModel.replytext
                                        } else {
                                            return commentModel.commenttext
                                        }
                                    },
                                    set: {
                                        // Dont't set if comments are loading
                                        guard !commentModel.isLoading else { return }
                                        
                                        // Set the replytext or commenttext depending on whether you're replying to a comment or not
                                        if replyingToCommentId != nil {
                                            commentModel.replytext = $0
                                        } else {
                                            commentModel.commenttext = $0
                                        }
                                    }
                                ),
                                prompt: Text(replyingToCommentId != nil ? "add reply!" : " add comment!").font(.custom("LexendDeca-Regular", size: 15))
                            )
                            .onTapGesture {
                                isEditing = true
                            }
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Theme.Peach))
                        }
                           
                                     
                        if (isEditing && commentModel.commenttext != "") || (isEditing && commentModel.replytext != "") {
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
                
                ToolbarItem(placement: .navigationBarTrailing){
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
            self.commentModel.isLoading = true
            self.commentModel.getComments(postId: postId)
            self.commentModel.isLoading = false
        }
        .onReceive(commentModel.$comments) { _ in
            commentModel.comments.forEach { comment in
                commentModel.isLoading = true
                commentModel.getReplies(postId: postId, commentId: comment.id)
                commentModel.isLoading = false
            }
        }
    }
    func createContent() {
        if let replyingId = replyingToCommentId {
            commentModel.createReply(commentId: replyingId, postId: postId) {
                commentModel.getReplies(postId: postId, commentId: replyingId)
                commentModel.replytext = ""  // Reset here
                replyingToCommentId = nil
            }
        } else {
            commentModel.createComment(postId: postId) {
                commentModel.getComments(postId: postId)
                commentModel.commenttext = ""
            }
        }
        UIApplication.shared.dismissKeyboard()
    }
}

struct CommentsList: View {
    @EnvironmentObject var commentModel: CommentsModel
    @Binding var replyingToCommentId: String?
    
    var postID: String
    var body: some View {
        ScrollView {
            if commentModel.isLoading {
                ProgressView()
            }
            else if commentModel.comments.count == 0 {
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
                    CommentView(eachcomment: comment, comId: comment.id, postID: postID, replyingToCommentId: $replyingToCommentId)
                        .environmentObject(commentModel)
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
