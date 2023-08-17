//
//  FeedCells.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/8/23.
//

import SwiftUI
import AVKit
import UIKit
import Kingfisher

enum ActiveSheet: Identifiable {
    case first
    case second
    case third
    var id: Int {
        hashValue
    }
}

struct PlayerContainerView: View {
    var player: AVPlayer?

    var body: some View {
        if let player = player {
            Player(player: player)
                .edgesIgnoringSafeArea(.top)
        }
    }
}


struct PlayerView: View {
    @ObservedObject var feedmodel: FeedPostModel
    var currentIndex: Int
    @StateObject var commentModel: CommentsModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    @State private var activeSheet: ActiveSheet?
    @StateObject var feedUpdate: FeedPostUpdateModel
    @ObservedObject var postLikeStatusModel: PostLikeStatusModel
    @StateObject var idsEqual = PosterIdEqualCurrentUserId()
    
    var body: some View {
        
        let currentPostPlayer = feedmodel.postPlayers[safe: currentIndex]
        NavigationView {
            ZStack {
                if let currentPostPlayer = currentPostPlayer, !currentPostPlayer.postItem.url.isEmpty {
                    KFImage(URL(string: currentPostPlayer.postItem.url))
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                }
                if let currentPostPlayer = currentPostPlayer {
                    PlayerContainerView(player: currentPostPlayer.player)
                        .onTapGesture {
                            guard let player = currentPostPlayer.player else { return }
                            if player.timeControlStatus == .playing {
                                player.pause()
                            } else {
                                player.play()
                            }
                        }
                        .onDisappear {
                            guard let player = currentPostPlayer.player else { return }
                            if player.timeControlStatus == .playing {
                                player.pause()
                            }
                        }
                }
                
                
                
                //- MARK: Hot/New button
                VStack {
                    HStack {
                        Button(action: {
                            feedmodel.isNewFeedSelected = false
                        }) {
                            Text("hot")
                                .font(.custom("LexendDeca-Bold", size:35))
                                .opacity(feedmodel.isNewFeedSelected ? 0.5 : 1.0)
                        }
                        Rectangle()
                            .frame(width: 2, height: 30)
                            .opacity(0.75)
                        Button(action: {
                            feedmodel.isNewFeedSelected = true
                        }) {
                            Text("new")
                                .font(.custom("LexendDeca-Bold", size: 35))
                                .opacity(feedmodel.isNewFeedSelected ? 1.0 : 0.5)
                        }
                    }
                    .padding(.top, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .foregroundColor(.white)
                
                VStack {
                    HStack {
                        Button(action: {
                            activeSheet = .first
                        }) {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        }
                    }
                    .padding(.top, 30)
                    .padding(.leading, 310)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                
                
                // -MARK: User information
                VStack {
                    HStack(alignment: .bottom) {
                        
                        VStack(alignment: .leading) {
                            
                            //- MARK: Profile pic/username buttons Hstack
                            NavigationLink(destination: {
                                    OtherProfilePage(profileModel: ProfileModel(id: currentPostPlayer!.postItem.posterId, currentUser: currentUser))
                            },
                                           label: {
                            HStack(spacing: 10) {
                                
                                Button(action: {
                                    // lead to profile page
                                }) {
                                    if let currentPostPlayer = currentPostPlayer {
                                        KFImage(URL(string: currentPostPlayer.postItem.profilepic))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    }
                                }
                                .padding(.bottom, 5)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                        if let currentPostPlayer = currentPostPlayer {
                                            Text("@\(currentPostPlayer.postItem.username)")
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                        }
                                    if let currentPostPlayer = currentPostPlayer {
                                        Text(currentPostPlayer.postItem.caption)
                                            .font(.custom("LexendDeca-Regular", size: 15))
                                    }
                                    if let currentPostPlayer = currentPostPlayer {
                                        if currentPostPlayer.postItem.location == "" {
                                            Text("")
                                        } else {
                                            Text( "\(currentPostPlayer.postItem.location)" + "📍")
                                                .font(.custom("LexendDeca-Regular", size: 15))
                                        }
                                    }
                                }
                                .padding(.leading, 10)
                            }
                        })
                            
                        }
                        
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 40)
                
                //-MARK: Three buttons on side
                VStack(spacing: 7.5) {
                    
                    VStack(spacing: -60) {
                        Button(action: {
                            if let currentPostPlayer = currentPostPlayer {
                                let postId = currentPostPlayer.postItem.id
                                let newLikeStatus = !(postLikeStatusModel.likedStatus[postId] ?? false)
                                
                                if newLikeStatus {
                                    feedUpdate.createLikeDocument(postId: currentPostPlayer.postItem.id, userId: currentUser.profile.userID)
                                    print("added like from post")
                                    feedUpdate.increasePosterUserLikes(posterUserId: currentPostPlayer.postItem.posterId)
                                    print("added like from user (from post)")
                                } else {
                                    feedUpdate.deleteLikeDocument(postId: currentPostPlayer.postItem.id, userId: currentUser.profile.userID)
                                    print("deleted like from post")
                                    feedUpdate.decreasePosterUserLikes(posterUserId: currentPostPlayer.postItem.posterId)
                                    print("deleted like from user (from post)")
                                }
                                postLikeStatusModel.likedStatus[postId] = newLikeStatus
                            }
                        }) {
                            VStack {
                                if let currentPostPlayer = currentPostPlayer {
                                    if postLikeStatusModel.likedStatus[currentPostPlayer.postItem.id] == true {
                                        Image("eaten")
                                    } else {
                                        Image("noteaten")
                                    }
                                }
                            }
                            .padding(.leading, -15)
                        }
                        Text("\(feedUpdate.likes.count)")
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Regular", size: 16))
                    }
                    
                    
                    
                    
                    VStack {
                        Button(action: {
                            activeSheet = .second
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
                    }
                    .padding(.top, 20)
                    
                    
                    Button(action: {
                        activeSheet = .third
                    }) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 35, height: 13)
                            .foregroundColor(.white)
                    }
                    .frame(height: 35)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.top, 15)
                }
                .padding(.bottom, 155)
                .padding(.trailing, -30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
            .onAppear {
                if let currentPostPlayer = currentPostPlayer {
                    commentModel.postId = currentPostPlayer.postItem.id
                    feedUpdate.postId = currentPostPlayer.postItem.id
                }
                if let currentPostPlayer = currentPostPlayer {
                    if currentUser.profile.userID == currentPostPlayer.postItem.posterId {
                        idsEqual.isEqual = true
                    }
                }
            }
            .sheet(isPresented: $currentUser.showInitialMessage) {
                InitialMessage(school: currentUser.profile.school)
                    .onDisappear {
                                    currentUser.showInitialMessage = false
                    }
                    .presentationDetents([.fraction(0.75)])
            }
            .background(Color.black.ignoresSafeArea())
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .first:
                    LeaderboardPage(model: LeaderboardModel(currentUser: currentUser))
                        .presentationDragIndicator(.visible)
                        .presentationCornerRadius(30)
                case .second:
                    if let currentPostPlayer = currentPostPlayer {
                        CommentsPage(postId: currentPostPlayer.postItem.id, commentModel: commentModel)
                            .presentationDetents([.fraction(0.85)])
                            .presentationDragIndicator(.visible)
                    }
                case .third:
                    EllipsesButtonView(equalIds: idsEqual)
                        .presentationDetents([.fraction(0.10)])
                        .presentationDragIndicator(.visible)
                }
            }
    }
}
    



//Main thing playing the videos, think of this as theFeed View
// We'll put UI elements like likebutton, commentspage, ellipses, and userinfo on here
struct ScrollFeed: View {
    @StateObject var feedModel: FeedPostModel
    
    var body: some View {
        ZStack {
            PlayerScrollView(feedModel: feedModel)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

//This controls our actual scrollable ability, makes the vertical scrolling actually possible

struct PlayerScrollView: UIViewRepresentable {
    @ObservedObject var feedModel: FeedPostModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var postLikeStatusModel = PostLikeStatusModel()
    
    func makeCoordinator() -> Coordinator {
        return PlayerScrollView.Coordinator(parent1: self)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
           for subview in uiView.subviews {
               subview.removeFromSuperview()
           }

           for i in 0..<feedModel.postPlayers.count {
               let childView = UIHostingController(rootView: PlayerView(feedmodel: feedModel, currentIndex: i, commentModel: CommentsModel(currentUser: currentUser), feedUpdate: FeedPostUpdateModel(currentUser: currentUser), postLikeStatusModel: postLikeStatusModel)) // Passing index here
               childView.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * CGFloat(i), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
               uiView.addSubview(childView.view)
           }

           uiView.contentSize.height = UIScreen.main.bounds.height * CGFloat(feedModel.postPlayers.count)
       }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PlayerScrollView
        var index = 0
        
        init(parent1: PlayerScrollView) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let currentIndex = Int(scrollView.contentOffset.y / UIScreen.main.bounds.height)
            
            if index != currentIndex {
                index = currentIndex
                
                // Pause all
                parent.feedModel.postPlayers.forEach { postPlayer in
                    postPlayer.player?.pause()
                }
                
                // Play current one
                if let player = parent.feedModel.postPlayers[safe: currentIndex]?.player {
                           player.play()
                       }
            }
        }
    }
    
    func makeUIView(context: Context) -> UIScrollView {
            let view = UIScrollView()
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            view.contentInsetAdjustmentBehavior = .never
            view.isPagingEnabled = true
            view.delegate = context.coordinator
            return view
        }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
