//
//  CommentView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/10/23.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    var eachcomment: Comment
    var comId: String
    var postID: String
    var posterId: String
    @State private var showingReplies: Bool = false
    @ObservedObject var commentsModel: CommentsModel
    @EnvironmentObject var currentUser: CurrentUserModel
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
                                KFImage(URL(string: eachcomment.profilepic))
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
                                    Text(timeAgoSinceDate(eachcomment.date.dateValue()))  //time variable
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
                                if commentsModel.repliesByComment[comId]?.count ?? 0 > 0 {
                                Button(action:{
                                    self.showingReplies.toggle()
                                }) {
                                    HStack(spacing: 2){
                                        Text("View \(commentsModel.repliesByComment[comId]?.count ?? 0) replies")
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
                        //    CommentButtonLikeView(comLikeModel: eachcomment.comLikeModel)
                            Text("\(eachcomment.numLikes)")
                                .foregroundColor(Theme.TextColor)
                                .font(.custom("LexendDeca-SemiBold", size: 16))
                        }
                    }
                if showingReplies {
                    ForEach(commentsModel.repliesByComment[comId] ?? [], id: \.id) { reply in
                        ReplyView(eachreply: reply, comId: comId, postId: postID)
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




