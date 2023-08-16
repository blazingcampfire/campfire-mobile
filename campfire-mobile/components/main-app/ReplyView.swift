//
//  ReplyView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/11/23.
//

import SwiftUI
import Kingfisher

struct ReplyView: View {
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var individualReply: IndividualReply
    @State private var likeTap: Bool = false
    
    
    var body: some View {
        HStack() {
           
            HStack {
                Button(action: {
                    // navigate to profile
                }) {
                    KFImage(URL(string: individualReply.profilepic))
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
                        Text("@\(individualReply.username)")
                            .font(.custom("LexendDeca-Bold", size: 14))
                            .foregroundColor(Theme.TextColor)
                    }
                    
                    Text(individualReply.reply)
                        .font(.custom("LexendDeca-Light", size: 15))
                        .foregroundColor(Theme.TextColor)
                    
                    Text(timeAgoSinceDate(individualReply.date.dateValue()))  // time variable
                        .font(.custom("LexendDeca-Light", size: 13))
                        .foregroundColor(Theme.TextColor)
                }
                .padding(.top, 20)
            }
            .padding(.leading, 60)
            
            Spacer()
            
            VStack(spacing: -20) {
                Button(action: {
                    individualReply.toggleLikeStatus()
                }) {
                    Image(individualReply.isLiked ? "eatensmore" : "noteatensmore")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(contentMode: .fill)
                        .offset(x: -4)
                }
                
                Text("\(formatNumber(individualReply.numLikes))")
                    .foregroundColor(Theme.TextColor)
                    .font(.custom("LexendDeca-SemiBold", size: 16))
                    .offset(x: -4, y: 20)
            }
        }
    }
}

//struct ReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyView(profilepic: "ragrboard6", username: "lowkeyme", reply: "hahaha", replyLikeNum: 2, replytime: "10m")
//    }
//}
