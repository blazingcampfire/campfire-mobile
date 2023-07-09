//
//  CommentsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/8/23.
//

import SwiftUI

struct CommentsPage: View {
    let feedinfo = FeedInfo()
    var body: some View {
        NavigationView {
                CommentsList(range: 1...10)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack() {
                            HStack() {
                                Text("Comments")
                                    .foregroundColor(Theme.TextColor)
                                    .font(.custom("LexendDeca-Bold", size: 23))
                             
                                Text("\(feedinfo.commentnum)")
                                    .foregroundColor(Theme.TextColor)
                                    .font(.custom("LexendDeca-Light", size: 16))
                            }
                            ZStack{
                                Button(action: {
                                    //button to dismiss view
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Theme.TextColor)
                                        .bold()
                                }
                            }
                            .padding(.leading, 160)
                            
                        }
                    }
                }
        }
      
    }
}

struct CommentsList: View {
    let range: ClosedRange<Int>
    @State private var commentLikeTapped: Bool = false
    let feedinfo = FeedInfo()
    
    
    var body: some View {
            List {
                ForEach(range, id: \.self) { number in
                    HStack {
                        
                        Image(info.profilepic)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text("@\(info.username)")
                                .font(.custom("LexendDeca-Bold", size: 14))
                                .foregroundColor(Theme.TextColor)
                            Text(feedinfo.comments)
                                .font(.custom("LexendDeca-Light", size: 16))
                                .foregroundColor(Theme.TextColor)
                            HStack(spacing: 15){
                                Text("1m")  //time variable
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
                                HStack(spacing: 2){
                                    Text("View 10 replies")
                                        .foregroundColor(Theme.TextColor)
                                        .font(.custom("LexendDeca-Light", size: 13))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 11))
                                }
                            }
                        }
                        .padding(.top, 40)
                        
                        Spacer()
                        
                        VStack(spacing: -20) {
                            Button(action: {
                                self.commentLikeTapped.toggle()
                            }) {
                                Image(self.commentLikeTapped == false ? "eaten" : "noteaten")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                            }
                            Text("\(feedinfo.commentnum)")
                                .foregroundColor(Theme.TextColor)
                                .font(.custom("LexendDeca-Regular", size: 16))
                        }
                    }
                    .listRowBackground(Theme.ScreenColor)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 15, bottom:0, trailing: 5))
                    .padding(.top, -15)
                }
            }
            .listStyle(PlainListStyle())
}
}






struct CommentsPage_Previews: PreviewProvider {
    static var previews: some View {
        CommentsPage()
    }
}
