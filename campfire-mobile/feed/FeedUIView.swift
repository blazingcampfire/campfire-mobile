//
//  FeedUIView.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/12/23.
//

import SwiftUI
import Kingfisher
import AVKit

enum ActiveSheet: Identifiable {
    case first
    case second
    case third
    case fourth
    var id: Int {
        hashValue
    }
}

struct FeedUIView: View {
    @ObservedObject var individualPost: IndividualPost
    @EnvironmentObject var currentUser: CurrentUserModel
    @State private var activeSheet: ActiveSheet?
    @StateObject var idsEqual = PosterIdEqualCurrentUserId() //For the ellipses button
    @ObservedObject var newFeedModel: NewFeedModel
    @State private var selection: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        newFeedModel.currentAssortment = .hot
                    }) {
                        Text("hot")
                            .font(.custom("LexendDeca-Bold", size: 37))
                            .opacity(newFeedModel.currentAssortment == .hot ? 1.0 : 0.5)
                    }
                    Rectangle()
                        .frame(width: 2, height: 30)
                        .opacity(0.75)
                    Button(action: {
                        newFeedModel.currentAssortment = .new
                    }) {
                        Text("new")
                            .font(.custom("LexendDeca-Bold", size: 37))
                            .opacity(newFeedModel.currentAssortment == .new ? 1.0 : 0.5)
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
                        
                        //- MARK: Profile pic/username buttons Hstack
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
                                
                                if individualPost.location == "" {
                                    Text("")
                                } else {
                                    Text( "\(individualPost.location)" + "📍")
                                        .font(.custom("LexendDeca-Regular", size: 15))
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
            if currentUser.showInitialMessage == true {
                activeSheet = .fourth
            }
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .first:
                LeaderboardPage(model: LeaderboardModel(currentUser: currentUser))
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(30)
            case .second:
                CommentsPage(commentModel: CommentsModel(currentUser: currentUser, postId: individualPost.id), post: individualPost)
                    .tint(Theme.Peach)
                    .presentationDetents([.fraction(0.85)])
                    .presentationDragIndicator(.visible)
            case .third:
                EllipsesButtonView(equalIds: idsEqual)
                    .presentationDetents([.fraction(0.50)])
                    .presentationDragIndicator(.visible)
                    .environmentObject(individualPost)
            case .fourth:
                InitialMessage(school: currentUser.profile.school)
            }
        }
//        .alert(title: "Delete Post", message: "Are you sure you want to delete your post",
//               dismissButton: CustomAlertButton(title: "yes", action: individualPost.deletePostDocument),
//               isPresented: $idsEqual.showAlert)
        .onTapGesture {
            idsEqual.showAlert = false
            currentUser.showInitialMessage = false
        }
    }
    
    }




//struct FeedUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedUIView()
//    }
//}