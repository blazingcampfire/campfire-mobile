//  TheFeed.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//
import SwiftUI
import AVKit
import Kingfisher


struct TheFeed: View {
   @StateObject var postModel = FeedPostModel()

    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView {
                ForEach(postModel.postPlayers.compactMap {$0}){ player in
                    PostPlayerView(postPlayer: player, feedmodel: postModel)
                            .frame(width: size.width)
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all, edges: .top)
                }
            }
            .rotationEffect(.init(degrees: 90))
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width)
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.ignoresSafeArea())
    }
}
//In this view a Tabview is iterating over the VidsPlayer View and setting up the vertical scroll ui component
//VidsPlayer handles the specific actions of what each case should look like

//struct TheFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        TheFeed(postModel: FeedPostModel(), handlecomments: CommentsModel())
//    }
//}
    
struct PostPlayerView: View {
    var postPlayer: PostPlayer
    @State private var HotSelected = true
    @State private var leaderboardPageShow = false
    @State private var commentsTapped = false
    @State private var likedTapped: Bool = false
    @State private var isPlaying = true
    @ObservedObject var feedmodel: FeedPostModel
    @StateObject var commentModel = CommentsModel()
    
    
    
    //-MARK: Sets up the VideoPlayer for the video case and the creates the image url and handles image case
    var body: some View {
             ZStack {
                 if postPlayer.postItem.postType == "video" {
                     if let urlPlayer = self.postPlayer.player {
                         CustomVideoPlayer(player: urlPlayer, isPlaying: $isPlaying)
                             .onTapGesture {
                                 isPlaying.toggle()
                             }
                             .onDisappear {
                                 isPlaying = false
                             }
                     } else {
                         Text("Error Loading Post")
                             .font(.custom("LexendDeca-Regular", size: 25))
                             .foregroundColor(.white)
                     }
                     
                 } else if postPlayer.postItem.postType == "image" {
                     let imageURL = postPlayer.postItem.url
                     KFImage(URL(string: imageURL))
                         .resizable()
                         .scaledToFit()
                         .edgesIgnoringSafeArea(.all)
                     
                 } else {
                     Text("Error Loading Post")
                         .font(.custom("LexendDeca-Regular", size: 25))
                         .foregroundColor(.white)
                 }
                 
                 
                 
               //- MARK: Hot/New button
                VStack {
                    HStack {
                        Button(action: {
                            HotSelected = true
                        }) {
                            Text("Hot")
                                .font(.custom("LexendDeca-Bold", size:35))
                                .opacity(HotSelected ? 1.0 : 0.5)
                        }
                        
                        Rectangle()
                            .frame(width: 2, height: 30)
                            .opacity(0.75)
                        Button(action: {
                            HotSelected = false
                        }) {
                            Text("New")
                                .font(.custom("LexendDeca-Bold", size: 35))
                                .opacity(HotSelected ? 0.5 : 1.0)
                        }
                    }
                    .padding(.top, 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.white)
            
            VStack {
                HStack {
                    Button(action: {
                        leaderboardPageShow.toggle()
                    }) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $leaderboardPageShow) {
                        LeaderboardPage()
                            .presentationDragIndicator(.visible)
                            .presentationCornerRadius(30)
                    }
                }
                .padding(.top, 65)
                .padding(.leading, 310)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            
                //-MARK: User information
                 VStack {
                    HStack(alignment: .bottom) {
                        
                        VStack(alignment: .leading, spacing: -5) {
                            
                            
                            //- MARK: Profile pic/username buttons Hstack
                            HStack(spacing: 10) {
                                
                                Button(action: {
                                    // lead to profile page
                                }) {
                                    KFImage(URL(string: postPlayer.postItem.profilepic))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                .padding(.bottom, 5)
                                
                                
                                Button(action: {
                                    //lead to profile page
                                }) {
                                    Text("@\(postPlayer.postItem.username)")
                                        .font(.custom("LexendDeca-Bold", size: 16))
                                }
                            }
                            
                            //- MARK: Caption/Location buttons Vstack
                            VStack(spacing: 5) {
                                HStack {
                                    Text(postPlayer.postItem.caption)
                                        .font(.custom("LexendDeca-Regular", size: 16))
                                }
                             
                                
                                Button(action: {
                                    //lead to map and where location is
                                }) {
                                    HStack {
                                        Text("📍" + "\(postPlayer.postItem.location)")
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                             
                                }
                                .frame(alignment: .trailing)
                            }
                            .padding(.leading, 40)
                        }
                    }
                    .padding(.leading, 40)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 30)
                .padding(.leading, -20)
                
                
                //-MARK: End of profile info
                
                
                //-MARK: Three buttons on side
                VStack(spacing: 7.5) {
                    
                    VStack(spacing: -60) {
                        Button(action: {
                        self.likedTapped.toggle()
                        feedmodel.updateLikeCount(postId: postPlayer.postItem.id)
                        }) {
                            VStack {
                                Image(self.likedTapped == true ? "eaten" : "noteaten")
                            }
                            .padding(.leading, -15)
                        }
                        Text("\(postPlayer.postItem.numLikes)")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
                    }
                    
                    VStack {
                        Button(action: {
                            self.commentsTapped.toggle()
                            }) {
                            VStack {
                                Image(systemName: "text.bubble.fill")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white)
                                }
                            }
                        Text("\(commentModel.comments.count)")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
                            .sheet(isPresented: $commentsTapped) {
                                CommentsPage(postId: postPlayer.postItem.id, commentModel: commentModel)
                            .presentationDetents([.fraction(0.85)])
                            .presentationDragIndicator(.visible)
                                }
                            }
                            .padding(.top, 20)
              
                    
                    Button(action: {
                        //report post
                        //delete post if user's post
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 30, height: 7)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                }
                .padding(.bottom, 155)
                .padding(.trailing, -30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
             .onAppear {
                 commentModel.postId = postPlayer.postItem.id
             }
        .background(Color.black.ignoresSafeArea())
    }
}
