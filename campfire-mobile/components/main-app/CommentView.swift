//
//  CommentView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/10/23.
//

import SwiftUI

struct CommentView: View {
    var profilepic: String
    var username: String
    var comment: String
    var commentLikeNum: Int
    var numReplies: Int
    var commenttime: String
    @State private var commentLiked: Bool = false
    
    
    var body: some View {
        HStack {
            
            HStack(spacing: 5){
                Button(action: {
                    //navigate to profile
                }) {
                    Image(profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.trailing, 5)
                
                
                VStack(alignment: .leading, spacing: 2) {
                    
                    Button(action: {
                        //navigate to profile
                    }) {
                        Text("@\(username)")
                            .font(.custom("LexendDeca-Bold", size: 14))
                            .foregroundColor(Theme.TextColor)
                    }
                    
                    Text(comment)
                        .font(.custom("LexendDeca-Light", size: 15))
                        .foregroundColor(Theme.TextColor)
                    
                    HStack(spacing: 15){
                        Text(commenttime)  //time variable
                            .font(.custom("LexendDeca-Light", size: 13))
                            .foregroundColor(Theme.TextColor)
                        
                        
                        Button(action: {
                            
                        }) {
                            Text("Reply")
                                .font(.custom("LexendDeca-SemiBold", size: 13))
                                .foregroundColor(Theme.TextColor)
                        }
                    }
                    Button(action:{
                        
                    }) {
                        if numReplies != 0 {
                            HStack(spacing: 2){
                                Text("View \(numReplies) replies")
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
            }) {
                Image(commentLiked == false ? "noteaten" : "eaten")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .offset(x: -4)
            }
            Text("\(commentLikeNum)")
                .foregroundColor(Theme.TextColor)
                .font(.custom("LexendDeca-SemiBold", size: 16))
        }
     
    }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(profilepic: "ragrboard2", username: "urmom122", comment: "fw the kid", commentLikeNum: 15, numReplies: 1, commenttime: "2d")
    }
}



