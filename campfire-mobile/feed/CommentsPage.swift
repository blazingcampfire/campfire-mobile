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
                .background(Theme.ScreenColor)
        }
        .background(Theme.ScreenColor)
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

                    VStack(alignment: .leading) {
                        Text("@\(info.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                        Text(feedinfo.comments)
                            .font(.custom("LexendDeca-Regular", size: 16))
                            .foregroundColor(Theme.TextColor)
                        
                    }

                    Spacer()

                    VStack {
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
           //     .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
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
