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
    @State private var selectedTab = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $selectedTab) {  // Use this line instead of the former TabView
                ForEach(postModel.postPlayers.indices, id: \.self) { index in
                    if let player = postModel.postPlayers[index] {
                        PostPlayerView(postPlayer: player, feedmodel: postModel)
                            .frame(width: size.width)
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all, edges: .top)
                            .tag(index)  // Add this line
                    }
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

struct TheFeed_Previews: PreviewProvider {
    static var previews: some View {
        TheFeed(postModel: FeedPostModel())
    }
}
    
struct PostPlayerView: View {
    var postPlayer: PostPlayer
    @State var HotSelected: Bool = true
    @State private var leaderboardPageShow = false
    @State private var commentsTapped = false
    @State private var likedTapped: Bool = false
    @State private var isPlaying = true
    @State private var doubleTapped: Bool = false
    @State private var scale: CGFloat = 0
    @State private var showLikedImage = false
    @ObservedObject var feedmodel: FeedPostModel
    @StateObject var commentModel = CommentsModel()
    @EnvironmentObject var currentUser: CurrentUserModel
    
    
    
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
                           // HotSelected = true
                            feedmodel.isNewFeedSelected = false
                        }) {
                            Text("Hot")
                                .font(.custom("LexendDeca-Bold", size:35))
                                .opacity(feedmodel.isNewFeedSelected ? 0.5 : 1.0)
                        }
                        Rectangle()
                            .frame(width: 2, height: 30)
                            .opacity(0.75)
                        Button(action: {
                          //  HotSelected = false
                            feedmodel.isNewFeedSelected = true
                        }) {
                            Text("New")
                                .font(.custom("LexendDeca-Bold", size: 35))
                                .opacity(feedmodel.isNewFeedSelected ? 1.0 : 0.5)
                        }
                    }
                    .padding(.top, 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.white)
            
                 if self.showLikedImage {
                     Image("eaten")
                         .resizable()
                         .frame(width: 450, height: 450)
                         .padding()
                         .scaleEffect(scale)
                         .animation(.easeOut(duration: 1.0), value: scale)
                         .onAppear {
                             DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                 self.showLikedImage = false
                             }
                         }
                 }
                 
                 
                 
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
                        LeaderboardPage(model: LeaderboardModel(currentUser: currentUser))
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
                        
                        VStack(alignment: .leading) {
                            
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
                                
<<<<<<< HEAD
                                
                                Button(action: {
                                    //lead to profile page
                                }) {
                                    Text("@\(postPlayer.postItem.username)")
                                        .font(.custom("LexendDeca-Bold", size: 16))
                                }
                            }
                            
                            //- MARK: Caption/Location buttons Vstack
                                VStack {
                                    Text(postPlayer.postItem.caption)
                                        .font(.custom("LexendDeca-Regular", size: 16))
                                    if postPlayer.postItem.location == "" {
                                        Text("")
                                    } else {
                                        Text("📍" + "\(postPlayer.postItem.location)")
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                                }
                                .padding(.leading, 40)
=======
                                VStack(alignment: .leading, spacing: 5) {
                                    Button(action: {
                                        //lead to profile page
                                    }) {
                                        Text("@\(postPlayer.postItem.username)")
                                            .font(.custom("LexendDeca-Bold", size: 16))
                                    }
                                    
                                    Text(postPlayer.postItem.caption)
                                        .font(.custom("LexendDeca-Regular", size: 15))
                                    if postPlayer.postItem.location == "" {
                                        Text("")
                                    } else {
                                        Text( "\(postPlayer.postItem.location)" + "📍")
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                                }
                                .padding(.leading, 10)
                                
                                
                            }
                            
                        }
                                
>>>>>>> dev
                        }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 40)
                
                
                //-MARK: End of profile info
                
                
                //-MARK: Three buttons on side
                 VStack(spacing: 7.5) {
                     
                     VStack(spacing: -60) {
                         Button(action: {
                             self.likedTapped.toggle()
                             if likedTapped {
                                 if !doubleTapped {
                                     feedmodel.increaseLikeCount(postId: postPlayer.postItem.id)
                                 }
                             } else {
                                 feedmodel.decreaseLikeCount(postId: postPlayer.postItem.id)
                             }
                             self.doubleTapped = self.likedTapped
                         }) {
                             VStack {
                                 Image(self.likedTapped || self.doubleTapped == true ? "eaten" : "noteaten")
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
             .onTapGesture(count: 2) {
                 if !self.likedTapped {
                     self.likedTapped = true
                     feedmodel.increaseLikeCount(postId: postPlayer.postItem.id)
                     self.doubleTapped = self.likedTapped
                 }
               scale = 1
                 withAnimation {
                     scale = 1.3
                 }
                 self.showLikedImage = true
             }
        .background(Color.black.ignoresSafeArea())
    }
}
