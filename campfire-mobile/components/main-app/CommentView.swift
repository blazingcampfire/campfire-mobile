//
//  CommentView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/10/23.
//

import SwiftUI

struct CommentView: View {
    var eachcomment: Comment
    var comId: String
    var postID: String
    @State private var commentLiked: Bool = false
    @State private var showingReplies: Bool = false
    @State private var replyTapped: Bool = false
    @ObservedObject var commentsModel: CommentsModel
    @Binding var replyingToComId: String?
    @Binding var replyingToUserId: String?
    var usernameId: String
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) { //View Replies wrapped
                    HStack { //Profile pic to comment info to like button wrapped horizontally
                        HStack(spacing: 5){
                            Button(action: {
                                //navigate to profile
                            }) {
                                Image("ragrboard5")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 5)
                            
                            //-MARK: Comment Info
                            VStack(alignment: .leading, spacing: 2) {
                                Button(action: {
                                    //navigate to profile
                                }) {
                                    Text("@\(eachcomment.username)")
                                        .font(.custom("LexendDeca-Bold", size: 14))
                                        .foregroundColor(Theme.TextColor)
                                }
                                
                                Text(eachcomment.comment)
                                    .font(.custom("LexendDeca-Light", size: 15))
                                    .foregroundColor(Theme.TextColor)
                                
                                HStack(spacing: 15){
                                    Text(eachcomment.date)  //time variable
                                        .font(.custom("LexendDeca-Light", size: 13))
                                        .foregroundColor(Theme.TextColor)
                                    
                                    Button(action: {
                                       replyingToComId = comId
                                        replyingToUserId = usernameId
                                    }) {
                                        Text("Reply")
                                            .font(.custom("LexendDeca-SemiBold", size: 13))
                                            .foregroundColor(Theme.TextColor)
                                    }
                                }
                                if commentsModel.replies.count > 0 {
                                Button(action:{
                                    self.showingReplies.toggle()
                                }) {
                                    HStack(spacing: 2){
                                        Text("View \(commentsModel.replies.count) replies")
                                            .foregroundColor(Theme.TextColor)
                                            .font(.custom("LexendDeca-Light", size: 13))
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 11))
                                            .foregroundColor(Theme.TextColor)
                                    }
                                }
                            }
                            }
                            .padding(.top, 30)
                            
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        
                        VStack(spacing: -20) {
                            Button(action: {
                                self.commentLiked.toggle()
                                if self.commentLiked {
                                    commentsModel.increaseCommentLikeCount(postId: postID, commentId: comId)
                                } else {
                                    commentsModel.decreaseComLikeCount(postId: postID, commentId: comId)
                                }
                            }) {
                                Image(commentLiked == true ? "eaten" : "noteaten")
                                    .resizable()
                                    .frame(width: 75, height: 90)
                                    .aspectRatio(contentMode: .fit)
                                    .offset(x: -4)
                            }
                            Text("\(eachcomment.numLikes)")
                                .foregroundColor(Theme.TextColor)
                                .font(.custom("LexendDeca-SemiBold", size: 16))
                        }
                    }
                if showingReplies {
                    ForEach(commentsModel.replies, id: \.id) { reply in
                        ReplyView(eachreply: reply, comId: comId, postId: postID, commentModel: commentsModel)
                    }
                }
        }
        }
        .onAppear {
            commentsModel.commentId = comId
        }
    }
    }
//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(profilepic: "ragrboard2", username: "urmom122", comment: "fw the kid", commentLikeNum: 15, commenttime: "2d")
//        CommentView(profilepic: "ragrboard", username: "fefe", comment: "fefe", commentLikeNum: 10, commenttime: "3m", replies: [ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m"), ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m"), ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m")])
//    }
//}




