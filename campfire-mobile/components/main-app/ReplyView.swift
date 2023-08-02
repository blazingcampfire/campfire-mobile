//
//  ReplyView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/11/23.
//

import SwiftUI

struct ReplyView: View {
    var eachreply: Reply
    @State private var replyLiked: Bool = false
    var body: some View {
        HStack() {
           
            HStack {
                Button(action: {
                    // navigate to profile
                }) {
                    Image("ragrboard5")
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
                    
                    Text(eachreply.date)  // time variable
                        .font(.custom("LexendDeca-Light", size: 13))
                        .foregroundColor(Theme.TextColor)
                }
                .padding(.top, 20)
            }
            .padding(.leading, 60)
            
            Spacer()

            VStack(spacing: -20) {
                Button(action: {
                    self.replyLiked.toggle()
                }) {
                    Image(replyLiked == false ? "noteaten" : "eaten")
                        .resizable()
                        .frame(width: 75, height: 90)
                        .aspectRatio(contentMode: .fill)
                        .offset(x: -2)
                }
                
                Text("\(eachreply.numLikes)")
                    .foregroundColor(Theme.TextColor)
                    .font(.custom("LexendDeca-SemiBold", size: 16))
            }
        }
        
    }
}

//struct ReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyView(profilepic: "ragrboard6", username: "lowkeyme", reply: "hahaha", replyLikeNum: 2, replytime: "10m")
//    }
//}
