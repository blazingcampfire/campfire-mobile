////
////  NewFeed.swift
////  campfire-mobile
////
////  Created by Femi Adebogun on 8/3/23.
////
//
//import SwiftUI
//import AVKit
//import Kingfisher
//
//
//struct NewFeed: View {
//    @StateObject var postModel = FeedPostModel()
//    @StateObject var commentModel = CommentsModel()
//    @State private var isPlaying: Bool = true
//
//    var body: some View {
//            GeometryReader { proxy in
//                let size = proxy.size
//                TabView {
//                    ForEach(postModel.posts) { post in
//                        if post.postType == "image" {
//                            KFImage(URL(string: post.url))
//                                .resizable()
//                                .scaledToFit()
//                                .overlay(
//                                    // Place FeedUI on top as an overlay
//                                    FeedUI(comments: commentModel, profilepic: post.profilepic, username: post.username, caption: post.caption, location: post.location, postLikes: post.numLikes, postId: post.id)
//                                )
//                        }
//                        else if post.postType == "video", let videoURL = URL(string: post.url) {
//                            Group {
//                                CustomVideoPlayer(player: AVPlayer(url: videoURL), isPlaying: $isPlaying)
//                                    .edgesIgnoringSafeArea(.all)
//                                    .onAppear {
//                                        isPlaying = true
//                                    }
//                                    .onDisappear {
//                                        isPlaying = false
//                                    }
//                                FeedUI(comments: commentModel, profilepic: post.profilepic, username: post.username, caption: post.caption, location: post.location, postLikes: post.numLikes, postId: post.id)
//                            }
//                        }
//                    }
//                    .frame(width: size.width)
//                    .rotationEffect(.init(degrees: -90))
//                    .ignoresSafeArea(.all, edges: .top)
//                }
//                .rotationEffect(.init(degrees: 90))
//                .frame(width: size.height)
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                .frame(width: size.width)
//            }
//            .background(Color.black.ignoresSafeArea())
//        }
//}
//
//struct FeedUI: View {
//    @State private var likeTapped: Bool = false
//    @State private var HotSelected = true
//    @State private var leaderboardPageShow = false
//    @State private var commentsTapped = false
//    @ObservedObject var comments: CommentsModel
//    var profilepic: String
//    var username: String
//    var caption: String
//    var location: String
//    var postLikes: Int
//    var postId: String
//
//    var body: some View {
//        ZStack {
//            //- MARK: Hot/New button
//                       VStack {
//                           HStack {
//                               Button(action: {
//                                   HotSelected = true
//                               }) {
//                                   Text("Hot")
//                                       .font(.custom("LexendDeca-Bold", size:35))
//                                       .opacity(HotSelected ? 1.0 : 0.5)
//                               }
//
//                               Rectangle()
//                                   .frame(width: 2, height: 30)
//                                   .opacity(0.75)
//                               Button(action: {
//                                   HotSelected = false
//                               }) {
//                                   Text("New")
//                                       .font(.custom("LexendDeca-Bold", size: 35))
//                                       .opacity(HotSelected ? 0.5 : 1.0)
//                               }
//                           }
//                           .padding(.top, 60)
//                       }
//                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                       .foregroundColor(.white)
//
//                   VStack {
//                       HStack {
//                           Button(action: {
//                               leaderboardPageShow.toggle()
//                           }) {
//                               Image(systemName: "trophy.fill")
//                                   .foregroundColor(.white)
//                                   .font(.system(size: 30))
//                           }
//                           .sheet(isPresented: $leaderboardPageShow) {
//                               LeaderboardPage()
//                                   .presentationDragIndicator(.visible)
//                                   .presentationCornerRadius(30)
//                           }
//                       }
//                       .padding(.top, 65)
//                       .padding(.leading, 310)
//                   }
//                   .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//
//
//
//
//
//                       //-MARK: User information
//                        VStack {
//                           HStack(alignment: .bottom) {
//
//                               VStack(alignment: .leading, spacing: -5) {
//
//
//                                   //- MARK: Profile pic/username buttons Hstack
//                                   HStack(spacing: 10) {
//
//                                       Button(action: {
//                                           // lead to profile page
//                                       }) {
//                                           KFImage(URL(string: profilepic))
//                                               .resizable()
//                                               .aspectRatio(contentMode: .fill)
//                                               .frame(width: 40, height: 40)
//                                               .clipShape(Circle())
//                                       }
//                                       .padding(.bottom, 5)
//
//
//                                       Button(action: {
//                                           //lead to profile page
//                                       }) {
//                                           Text("@\(username)")
//                                               .font(.custom("LexendDeca-Bold", size: 16))
//                                       }
//                                   }
//
//                                   //- MARK: Caption/Location buttons Vstack
//                                   VStack(spacing: 5) {
//                                       HStack {
//                                           Text(caption)
//                                               .font(.custom("LexendDeca-Regular", size: 16))
//                                       }
//
//
//                                       Button(action: {
//                                           //lead to map and where location is
//                                       }) {
//                                           HStack {
//                                               Text("📍" + "\(location)")
//                                                   .font(.custom("LexendDeca-Regular", size: 15))
//                                           }
//
//                                       }
//                                       .frame(alignment: .trailing)
//                                   }
//                                   .padding(.leading, 40)
//                               }
//                           }
//                           .padding(.leading, 40)
//                       }
//                       .foregroundColor(.white)
//                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                       .padding(.bottom, 30)
//                       .padding(.leading, -20)
//
//
//                       //-MARK: End of profile info
//
//
//                       //-MARK: Three buttons on side
//                       VStack(spacing: 7.5) {
//
//                           VStack(spacing: -60) {
//                               Button(action: {
//                                   //like post
//                                   self.likeTapped.toggle()
//                               }) {
//                                   VStack {
//                                       Image(self.likeTapped == true ? "eaten" : "noteaten")
//                                   }
//                                   .padding(.leading, -15)
//                               }
//                               Text("\(postLikes)")
//                                   .foregroundColor(.white)
//                                   .font(.custom("LexendDeca-Regular", size: 16))
//                           }
//                         //  VStack {
////                           Button(action: {
////                               self.commentsTapped.toggle()
////                           }) {
////                               VStack {
////                                   Image(systemName: "text.bubble.fill")
////                                       .resizable()
////                                       .frame(width: 35, height: 35)
////                                       .foregroundColor(.white)
////                               }
////                           }
////                               Text("\(comments.comments.count)")
////                               .foregroundColor(.white)
////                               .font(.custom("LexendDeca-Regular", size: 16))
////                               .sheet(isPresented: $commentsTapped) {
////                                   CommentsPage(postId: postId, commentModel: comments)
////                                       .presentationDetents([.fraction(0.85)])
////                                       .presentationDragIndicator(.visible)
////                               }
////                       }
////                           .padding(.top, 20)
//
//
//                           Button(action: {
//                               //report post
//                               //delete post if user's post
//                           }) {
//                               Image(systemName: "ellipsis")
//                                   .resizable()
//                                   .frame(width: 30, height: 7)
//                                   .foregroundColor(.white)
//                           }
//                           .padding(.top, 15)
//                       }
//                       .padding(.bottom, 155)
//                       .padding(.trailing, -30)
//                       .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                   }
//        .background(Color.black.ignoresSafeArea())
//        }
//    }
//
//
//
//
//
