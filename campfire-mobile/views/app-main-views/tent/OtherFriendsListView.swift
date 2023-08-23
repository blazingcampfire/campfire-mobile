//
//  OtherFriendsListView.swift
//  campfire-mobile
//
//  Created by Toni on 8/13/23.
//

import Kingfisher
import SwiftUI

struct OtherFriendsListView: View {
    var request: RequestFirestore
    @EnvironmentObject var model: FriendsModel
    @EnvironmentObject var currentUser: CurrentUserModel
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)

            HStack {
                HStack {
                    // user image is passed in
                    KFImage(URL(string: request.profilePicURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Button(action: {
                        }) {
                            Text(request.name)
                                .font(.custom("LexendDeca-Bold", size: 18))
                                .foregroundColor(Theme.TextColor)
                        }

                        Text("@\(request.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .overlay(
                    NavigationLink(destination: { OtherProfilePage(profileModel: ProfileModel(id: request.userID, currentUser: currentUser)
                                   )
                                   },
                                   label: { EmptyView() })
                        .opacity(0)
                        .frame(width: 10, height: 10)
                )
                Spacer()
            }
        }
    }
}
