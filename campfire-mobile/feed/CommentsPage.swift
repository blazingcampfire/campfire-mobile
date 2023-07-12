//
//  CommentsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/8/23.
//

import SwiftUI


struct CommentsPage: View {
    let feedinfo = FeedInfo()
    @State private var commentText: String = ""
    @Environment(\.dismiss) var dismiss
  
    var body: some View {
        NavigationView {
            VStack {
                CommentsList()
                Divider()
                VStack {
                    HStack {
                        Image(info.profilepic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        TextField("add comment!", text: $commentText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .foregroundColor(Theme.Peach)
                                     )
                        if commentText != "" {
                            Button(action: {
                                // button to add comment
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(Theme.Peach)
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack {
                        Text("Comments")
                            .foregroundColor(Theme.TextColor)
                            .font(.custom("LexendDeca-Bold", size: 23))
                     
                        Text("\(feedinfo.commentnum)")
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
    }
}
    



struct CommentsList: View {
//    let diffComments = [CommentView(profilepic: "darsh", username: "reallyhim", comment: "i wanna lick his neck", commentLikeNum: 35, numReplies: 5, commenttime: "1m"), CommentView(profilepic: "ragrboard", username: "davoo", comment: "eat shit kid!", commentLikeNum: 520, numReplies: 92, commenttime: "1hr"), CommentView(profilepic: "toni", username: "bizzletonster", comment: "if he wanted to he would", commentLikeNum: 15, numReplies: 2, commenttime: "1d"), CommentView(profilepic: "ragrboard2", username: "urmom122", comment: "fw the kid", commentLikeNum: 10, numReplies: 0, commenttime: "2d"), CommentView(profilepic: "ragrboard3", username: "heynowdarshie", comment: "i love fruit loops", commentLikeNum: 90, numReplies: 2, commenttime: "3m"), CommentView(profilepic: "ragrboard4", username: "yaliebalie", comment: "yayyy", commentLikeNum: 12, numReplies: 0, commenttime: "2w"), CommentView(profilepic: "ragrboard5", username: "shelovewede", comment: "me personally...", commentLikeNum: 55, numReplies: 10, commenttime: "3w")]
    
    let diffComments: [CommentView] = []
    
        
    var body: some View {
        ScrollView {
            if diffComments.isEmpty {
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
                ForEach(0..<diffComments.count, id: \.self) { index in
                    diffComments[index]
                }
                
            }
           
        }
    }
}
      

struct CommentsPage_Previews: PreviewProvider {
    static var previews: some View {
        CommentsPage()
    }
}
