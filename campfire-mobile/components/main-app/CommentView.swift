//
//  CommentView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/10/23.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    @State private var showingReplies: Bool = false
    @ObservedObject var commentModel: CommentsModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var individualComment: IndividualComment
    @State private var likeTap: Bool = false
    @Binding var replyingToComId: String?
    @Binding var replyingToUserId: String?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) { //View Replies wrapped
                    HStack { //Profile pic to comment info to like button wrapped horizontally
                        HStack(spacing: 5){
                            NavigationLink(destination: OtherProfilePage(profileModel: ProfileModel(id: individualComment.commentItem.id, currentUser: currentUser)) , label: {
                                KFImage(URL(string: individualComment.profilepic))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            })
                            .padding(.trailing, 5)
                            
                            //-MARK: Comment Info
                            VStack(alignment: .leading, spacing: 2) {
                                NavigationLink(destination: OtherProfilePage(profileModel: ProfileModel(id: individualComment.commentItem.id, currentUser: currentUser)), label: {
                                    //navigate to profile
                                    Text("@\(individualComment.username)")
                                        .font(.custom("LexendDeca-Bold", size: 14))
                                        .foregroundColor(Theme.TextColor)
                                })
                                
                                Text(individualComment.comment)
                                    .font(.custom("LexendDeca-Light", size: 15))
                                    .foregroundColor(Theme.TextColor)
                                
                                HStack(spacing: 15){
                                    Text(timeAgoSinceDate(individualComment.date.dateValue()))  //time variable
                                        .font(.custom("LexendDeca-Light", size: 13))
                                        .foregroundColor(Theme.TextColor)
                                    
                                    Button(action: {
                                        replyingToComId = individualComment.comId
                                        replyingToUserId = individualComment.username
                                    }) {
                                        Text("Reply")
                                            .font(.custom("LexendDeca-SemiBold", size: 13))
                                            .foregroundColor(Theme.TextColor)
                                    }
                                }
                                if commentModel.repliesByComment[individualComment.comId]?.count ?? 0 > 0 {
                                Button(action:{
                                    self.showingReplies.toggle()
                                }) {
                                    HStack(spacing: 2){
                                        Text("View \(commentModel.repliesByComment[individualComment.comId]?.count ?? 0) replies")
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
                        
                        VStack(spacing: -15) {
                            Button(action: {
                                individualComment.toggleLikeStatus()
                            }) {
                                Image(individualComment.isLiked ? "eatensmore" : "noteatensmore")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .aspectRatio(contentMode: .fit)
                                    .offset(x: -6)
                            }
                            
                            Text("\(formatNumber(individualComment.numLikes))")
                                .foregroundColor(Theme.TextColor)
                                .font(.custom("LexendDeca-SemiBold", size: 16))
                                .offset(x: -6, y: 20)
                        }
                    }
                if showingReplies {
                    ForEach(commentModel.repliesByComment[individualComment.comId] ?? [], id: \.id) { reply in
                        ReplyView(individualReply: IndividualReply(replyItem: reply, postId: commentModel.postId, commentId: individualComment.comId))
                    }
                }
        }
        }
        .onAppear {
            commentModel.getRepliesFor = individualComment.comId
        }
        .tint(Theme.Peach)
    }
    }
//struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView(profilepic: "ragrboard2", username: "urmom122", comment: "fw the kid", commentLikeNum: 15, commenttime: "2d")
//        CommentView(profilepic: "ragrboard", username: "fefe", comment: "fefe", commentLikeNum: 10, commenttime: "3m", replies: [ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m"), ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m"), ReplyView(profilepic: "toni", username: "notthatguy", reply: "lol wtf", replyLikeNum: 4, replytime: "10m")])
//    }
//}




