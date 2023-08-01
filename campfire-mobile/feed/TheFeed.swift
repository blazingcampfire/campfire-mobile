//  TheFeed.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/20/23.
//
import SwiftUI
import AVKit
import Kingfisher

struct TheFeed: View {
  
    @ObservedObject var postModel = FeedPostModel()
    @State var currentPost: String = ""
    @State var items: [PostPlayer?] = []
    
    init() {
        postModel.getPosts()
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentPost) {
                ForEach(items.indices, id: \.self){ index in
                    if let player = items[index] {
                        PostPlayerView(player: player, isCurrentPost: $currentPost)
                            .frame(width: size.width)
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all, edges: .top)
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
        .onAppear {
            items = postModel.posts.map { post in
                if post.postType == "image" {
                return PostPlayer(player: nil, postItem: post)
                } else if post.postType == "video" {
                    guard let url = URL(string: post.url) else { return nil }
                    let player = AVPlayer(url: url)
                    return PostPlayer(player: player, postItem: post)
                } else {
                    return nil
                }
            }
        }
    }
}
//In this view a Tabview is iterating over the VidsPlayer View and setting up the vertical scroll ui component
//VidsPlayer handles the specific actions of what each case should look like

struct TheFeed_Previews: PreviewProvider {
    static var previews: some View {
        TheFeed()
    }
}
    
struct PostPlayerView: View {
    var player: PostPlayer
    @Binding var isCurrentPost: String
    @State private var likeTapped: Bool = false
    @State private var HotSelected = true
    @State var leaderboardPageShow = false
    @State var commentsTapped = false
    @State private var isPlaying = true
    

    //-MARK: Sets up the VideoPlayer for the video case and the creates the image url and handles image case
    var body: some View {
             ZStack {
                 if player.postItem.postType == "video" {
                     if let urlPlayer = self.player.player {
                         CustomVideoPlayer(player: urlPlayer, isPlaying: $isPlaying)
                             .onTapGesture {
                                 isPlaying.toggle()
                             }
                     } else {
                         Text("Error Loading Post")
                        .font(.custom("LexendDeca-Regular", size: 25))
                        .foregroundColor(.white)
                     }
                     
                 } else if player.postItem.postType == "image" {
                     let imageURL = player.postItem.url
                         KFImage(URL(string: imageURL))
                             .resizable()
                             .edgesIgnoringSafeArea(.all)
                           //  .aspectRatio(9/16, contentMode: .fill)
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
                                    KFImage(URL(string: player.postItem.profilepic))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                .padding(.bottom, 5)
                                
                                
                                Button(action: {
                                    //lead to profile page
                                }) {
                                    Text("@\(player.postItem.username)")
                                        .font(.custom("LexendDeca-Bold", size: 16))
                                }
                            }
                            
                            //- MARK: Caption/Location buttons Vstack
                            VStack(spacing: 5) {
                                HStack {
                                    Text(player.postItem.caption)
                                        .font(.custom("LexendDeca-Regular", size: 16))
                                }
                             
                                
                                Button(action: {
                                    //lead to map and where location is
                                }) {
                                    HStack {
                                        Text("📍" + "\(player.postItem.location)")
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
                            //like post
                            self.likeTapped.toggle()
                        }) {
                            VStack {
                                Image(self.likeTapped == true ? "eaten" : "noteaten")
                            }
                            .padding(.leading, -15)
                        }
                        Text("\(player.postItem.numLikes)")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
                    }
                    
                    
//                    VStack {
//                    Button(action: {
//                        commentsTapped.toggle()
//                    }) {
//                        VStack {
//                            Image(systemName: "text.bubble.fill")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                                .foregroundColor(.white)
//                        }
//                    }
//                        Text("\(vid.mediafile.commentCount)")
//                        .foregroundColor(.white)
//                        .font(.custom("LexendDeca-Regular", size: 16))
//                        .sheet(isPresented: $commentsTapped) {
//                            CommentsPage(comments: vid.mediafile.commentSection)
//                                .presentationDetents([.fraction(0.85)])
//                                .presentationDragIndicator(.visible)
//                        }
//                }
//                    .padding(.top, 20)
                    
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
        .background(Color.black.ignoresSafeArea())
    }
}
