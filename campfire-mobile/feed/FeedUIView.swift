//
//  FeedUIView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import SwiftUI
import Kingfisher
import AVKit

struct FeedUIView: View {
    @ObservedObject var individualPost: IndividualPost
    @State private var likeTapped = false

    var body: some View {
        ZStack {
         
            VStack {
                HStack {
                    Button(action: {

                    }) {
                        Text("Hot")
                            .font(.custom("LexendDeca-Bold", size:35))
                    }
                    Rectangle()
                        .frame(width: 2, height: 30)
                        .opacity(0.75)
                    Button(action: {
                    }) {
                        Text("New")
                            .font(.custom("LexendDeca-Bold", size: 35))
                    }
                }
                .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .foregroundColor(.white)


            VStack {
                HStack {
                    Button(action: {

                    }) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
                .padding(.top, 38)
                .padding(.leading, 310)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)


            // -MARK: User information
            VStack {
                HStack(alignment: .bottom) {

                    VStack(alignment: .leading) {

                        //- MARK: Profile pic/username buttons Hstack
                        HStack(spacing: 10) {

                            Button(action: {
                                // lead to profile page
                            }) {
                                KFImage(URL(string: individualPost.profilepic))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())

                            }
                            .padding(.bottom, 5)

                            VStack(alignment: .leading, spacing: 5) {
                                Button(action: {
                                    //lead to profile page
                                }) {
                                    Text("@\(individualPost.username)")
                                            .font(.custom("LexendDeca-Bold", size: 16))
                                }

                                Text(individualPost.caption)
                                        .font(.custom("LexendDeca-Regular", size: 15))

                                if individualPost.location == "" {
                                        Text("")
                                    } else {
                                        Text( "\(individualPost.location)" + "📍")
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }

                            }
                            .padding(.leading, 10)
                        }

                    }

                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.bottom, 40)

            VStack(spacing: 7.5) {
                
                Text("\(individualPost.numLikes)")
                .foregroundColor(.white)
                .font(.custom("LexendDeca-Regular", size: 16))
                .padding(.bottom, -60)

                VStack {
                    Button(action: {
                   //     CommentsPage(postId: <#T##String#>, commentModel: <#T##CommentsModel#>)
                    }) {
                        VStack {
                            Image(systemName: "text.bubble.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                        }
                    }
                    Text("\("")")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-Regular", size: 16))
                }
                .padding(.top, 30)


                Button(action: {

                }) {
                    Image(systemName: "square.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                .padding(.top, 15)
            }
            .padding(.bottom, 155)
            .padding(.trailing, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .background(Color.clear)
    }
}


//struct FeedUILikeButton: View {
//    @State private var likeTapped: Bool = false
//
//    var body: some View {
//        Button(action: {
//            print("Button pressed")
//            self.onLikeTapped()
//        }) {
//            VStack(spacing: -60) {
//                Image(likeTapped ? "eatensmore" : "noteatensmore")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .padding(.top, -30)
//            }
//        }
//
//    }
//}
//struct FeedUILikeButton: View {
//    @Binding var likeTapped: Bool
//    @ObservedObject var individualPost: IndividualPost
//
//    var body: some View {
//        VStack(spacing: -60) {
//        Button(action: {
//            likeTapped.toggle()
//            if likeTapped {
//                individualPost.increasePostLikes()
//            } else {
//                individualPost.decreasePostLikes()
//            }
//        }) {
//            Image(likeTapped ? "eatensmore" : "noteatensmore")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .padding(.top, -30)
//        }
//        }
//
//    }
//}



//struct FeedUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedUIView()
//    }
//}
