//
//  SearchList.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI
import Kingfisher

struct SearchListView: View {
    var profile: Profile
    @EnvironmentObject var model: SearchModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            HStack {
                HStack {
                    KFImage(URL(string: profile.profilePicURL))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(profile.name)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .foregroundColor(Theme.TextColor)
                        Text("@\(profile.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .overlay (
                    NavigationLink(destination: {
                        OtherProfilePage(profileModel: ProfileModel(id: profile.userID, currentUser: currentUser))
                    },
                                   label: { EmptyView() })
                    .opacity(0)
                    .frame(width: 10, height: 10)
                )
                
                Spacer()
                
                HStack {
                    Text("\(profile.smores)")
                        .font(.custom("LexendDeca-Bold", size: 23))
                    Image("noteatensmore")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .scaledToFill()
                }
            }
        }
    }
}

