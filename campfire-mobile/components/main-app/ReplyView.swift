//
//  ReplyView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/11/23.
//

import SwiftUI
import Kingfisher

struct ReplyView: View {
    var eachreply: Reply
    var comId: String
    var postId: String
    var replyId: String
    var replyPosterId: String
    @ObservedObject var commentModel: CommentsModel
    @ObservedObject var replyLikeStatus: ReplyLikeStatusModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var replyUpdateModel = ReplyUpdateModel()
    
    
    var body: some View {
        HStack() {
           
            HStack {
                Button(action: {
                    // navigate to profile
                }) {
                    KFImage(URL(string: eachreply.profilepic))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.trailing, 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Button(action: {
                        // navigate to profile
                    }) {
                        Text("@\(eachreply.username)")
                            .font(.custom("LexendDeca-Bold", size: 14))
                            .foregroundColor(Theme.TextColor)
                    }
                    
                    Text(eachreply.reply)
                        .font(.custom("LexendDeca-Light", size: 15))
                        .foregroundColor(Theme.TextColor)
                    
                    Text(timeAgoSinceDate(eachreply.date.dateValue()))  // time variable
                        .font(.custom("LexendDeca-Light", size: 13))
                        .foregroundColor(Theme.TextColor)
                }
                .padding(.top, 20)
            }
            .padding(.leading, 60)
            
            Spacer()
            
            VStack(spacing: -20) {
                Button(action: {
                    let newLikeStatus = !(replyLikeStatus.likedStatus[replyId] ?? false)
                    print("Before: \(replyLikeStatus.likedStatus[replyId] ?? false)")
                    
                    if newLikeStatus {
                       replyUpdateModel.createLikeDocument(postId: postId, comId: comId, replyId: replyId, userId: currentUser.profile.userID)
                    } else {
                        replyUpdateModel.deleteLikeDocument(postId: postId, comId: comId, replyId: replyId, userId: currentUser.profile.userID)
                    }
                    
                    replyLikeStatus.likedStatus[replyId] = newLikeStatus
                    print("After: \(replyLikeStatus.likedStatus[replyId] ?? false)")
                }) {
                    Image(replyLikeStatus.likedStatus[replyId] == true ? "eaten" : "noteaten")
                        .resizable()
                        .frame(width: 75, height: 90)
                        .aspectRatio(contentMode: .fill)
                        .offset(x: -2)
                }
                Text("\(replyUpdateModel.replyLikes.count)")
                    .foregroundColor(Theme.TextColor)
                    .font(.custom("LexendDeca-SemiBold", size: 16))
            }
        }
        .onAppear {
            replyUpdateModel.postId = postId
            print("replyupdatemodel postid did set from on appear")
            replyUpdateModel.comId = comId
            print("replyupdatemodel comId did set from on appear")
            replyUpdateModel.replyId = replyId
            print("replyid did set from on appear")
        }
        
    }
}

//struct ReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyView(profilepic: "ragrboard6", username: "lowkeyme", reply: "hahaha", replyLikeNum: 2, replytime: "10m")
//    }
//}
