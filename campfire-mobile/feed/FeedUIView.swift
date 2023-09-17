//
//  FeedUIView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import AVKit
import Kingfisher
import SwiftUI

enum ActiveSheet: Identifiable {
    case first
    case second
    case third
    var id: Int {
        hashValue
    }
}

struct FeedUIView: View {
    @ObservedObject var individualPost: IndividualPost
    @EnvironmentObject var currentUser: CurrentUserModel
    @State private var activeSheet: ActiveSheet?
    @StateObject var idsEqual = PosterIdEqualCurrentUserId() // For the ellipses button
    @ObservedObject var newFeedModel: NewFeedModel
    @State private var selection: Int = 0

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            newFeedModel.currentAssortment = .new
                        }
                    }) {
                        Text("new")
                            .font(.custom("LexendDeca-Bold", size: 37))
                            .opacity(newFeedModel.currentAssortment == .new ? 1.0 : 0.5)
                    }
                    Rectangle()
                        .frame(width: 2, height: 30)
                        .opacity(0.75)
                    Button(action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            newFeedModel.currentAssortment = .hot
                        }
                    }) {
                        Text("hot")
                            .font(.custom("LexendDeca-Bold", size: 37))
                            .opacity(newFeedModel.currentAssortment == .hot ? 1.0 : 0.5)
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
                .padding(.top, 38)
                .padding(.leading, 310)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            // -MARK: User information
            VStack {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        // - MARK: Profile pic/username buttons Hstack
                        NavigationLink(destination: OtherProfilePage(profileModel: ProfileModel(id: individualPost.posterId, currentUser: currentUser)), label: {
                            HStack(spacing: 5) {
                                VStack {
                                    KFImage(URL(string: individualPost.profilepic))
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                .padding(.bottom, 25)
                                .padding(.leading, 20)

                                VStack(alignment: .leading, spacing: 5) {
                                    VStack {
                                        Text("@\(individualPost.username)")
                                            .font(.custom("LexendDeca-Bold", size: 16))
                                    }

                                    Text(individualPost.caption)
                                        .font(.custom("LexendDeca-Regular", size: 15))

                                    
                                    Text("\(formatAddress(individualPost.location, school: currentUser.profile.school))")
                                            .font(.custom("LexendDeca-Regular", size: 13))
                                        
                                    Text("posted \(postTimeAgoSinceDate(individualPost.postItem.date.dateValue()))")
                                        .font(.custom("LexendDeca-Bold", size: 13))
                                        .foregroundColor(Color.gray)
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

            VStack(spacing: 7.5) {
                Text("\(formatNumber(individualPost.numLikes))")
                    .foregroundColor(.white)
                    .font(.custom("LexendDeca-Regular", size: 16))
                    .padding(.bottom, -60)

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
                    Text("\(individualPost.comNum)")
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-Regular", size: 16))
                }
                .padding(.top, 30)

                Button(action: {
                    activeSheet = .third
                }) {
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(.top, 15)
            }
            .padding(.bottom, 155)
            .padding(.trailing, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .background(Color.clear)
        .onAppear {
            if currentUser.profile.userID == individualPost.posterId || currentUser.profile.email == "adg10@rice.edu" || currentUser.profile.email == "oakintol@nd.edu" || currentUser.profile.email == "david.adebogun@yale.edu" {
                idsEqual.isEqual = true
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .first:
                LeaderboardPage(model: LeaderboardModel(currentUser: currentUser))
                    .presentationDragIndicator(.visible)
            case .second:
                CommentsPage(commentModel: CommentsModel(currentUser: currentUser, postId: individualPost.id), post: individualPost)
                    .tint(Theme.Peach)
                    .presentationDetents([.fraction(0.85)])
                    .presentationDragIndicator(.visible)
            case .third:
                EllipsesButtonView(equalIds: idsEqual)
                    .presentationDetents([.fraction(0.50)])
                    .environmentObject(individualPost)
            }
        }
        .sheet(isPresented: $currentUser.showInitialMessage) {
            InitialMessage(school: currentUser.profile.school)
        }
        .onTapGesture {
            idsEqual.showAlert = false
            currentUser.showInitialMessage = false
        }
    }
}
