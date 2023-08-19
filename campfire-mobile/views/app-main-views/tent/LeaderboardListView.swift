//
//  LeaderboardListView.swift
//  campfire-mobile
//
//  Created by Toni on 8/12/23.
//

import Kingfisher
import SwiftUI

struct LeaderboardListView: View {
    var rank: Int
    var profile: Profile
    @EnvironmentObject var currentUser: CurrentUserModel

    var body: some View {
        HStack {
            HStack {
                Text("\(rank)")
                    .frame(width: 30, alignment: .leading)
                    .font(.custom("LexendDeca-Bold", size: 18))
                    .padding(.trailing, -10)
                
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
            .overlay(
                NavigationLink(destination: { OtherProfilePage(profileModel: ProfileModel(id: profile.userID, currentUser: currentUser))
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

//struct LeaderboardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardListView()
//    }
//}
