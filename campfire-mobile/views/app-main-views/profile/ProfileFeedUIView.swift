//
//  ProfileFeedUIView.swift
//  Campfire
//
//  Created by Femi Adebogun on 9/7/23.
//

import AVKit
import Kingfisher
import SwiftUI

enum Sheets: Identifiable {
    case first
    case second
    var id: Int {
        hashValue
    }
}

struct ProfileFeedUIView: View {
    @ObservedObject var individualPost: IndividualPost
    @EnvironmentObject var currentUser: CurrentUserModel
    @State private var activeSheet: Sheets?
    @StateObject var idsEqual = PosterIdEqualCurrentUserId() // For the ellipses button

    var body: some View {
        ZStack {

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
                                    .font(.custom("LexendDeca-Regular", size: 15))
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
                        activeSheet = .first
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
                    activeSheet = .second
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
                CommentsPage(commentModel: CommentsModel(currentUser: currentUser, postId: individualPost.id), post: individualPost)
                    .tint(Theme.Peach)
                    .presentationDetents([.fraction(0.85)])
                    .presentationDragIndicator(.visible)
            case .second:
                EllipsesButtonView(equalIds: idsEqual)
                    .presentationDetents([.fraction(0.50)])
                    .environmentObject(individualPost)
            }
        }
        .onTapGesture {
            idsEqual.showAlert = false
        }
    }
}
