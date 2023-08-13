//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI

let info = UserInfo()

struct LeaderboardPage: View {
    @StateObject var model: LeaderboardModel
    @State private var selectedOption = 5
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)

            VStack(spacing: 0) {
                Text("Leaderboard 👑")
                    .font(.custom("LexendDeca-SemiBold", size: 20))
                    .padding(.top, 15)

                LeaderboardList()
                    .environmentObject(model)
                    .listStyle(InsetListStyle())
            }
        }
    }
}

struct LeaderboardList: View {
    @EnvironmentObject var model: LeaderboardModel
    @EnvironmentObject var currentUser: CurrentUserModel

    var body: some View {
        List {
            ForEach(model.profiles.indices, id: \.self) { index in
                HStack {
                    HStack {
                    Text("\(index + 1)")
                        .frame(width: 30, alignment: .leading)
                        .font(.custom("LexendDeca-Bold", size: 18))
                        .padding(.trailing, -10)

                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(model.profiles[index].name)
                                .font(.custom("LexendDeca-Bold", size: 18))
                                .foregroundColor(Theme.TextColor)
                            Text("@\(model.profiles[index].username)")
                                .font(.custom("LexendDeca-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .overlay(
                        NavigationLink(destination: { OtherProfilePage(profileModel: ProfileModel(id: model.profiles[index].userID, currentUser: currentUser))
                        },
                                                           label: { EmptyView() })
                                            .opacity(0)
                                            .frame(width: 10, height: 10)
                                        )

                    Spacer()

                    Text("\(model.profiles[index].smores) 🍫")
                        .font(.custom("LexendDeca-Bold", size: 23))
                }
                .listRowBackground(Theme.ScreenColor)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 18, leading: 10, bottom: 15, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
}

// struct LeaderboardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardPage(model: LeaderboardModel())
//    }
//}


