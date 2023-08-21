//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/23/23.
//

import SwiftUI
import Kingfisher

struct LeaderboardPage: View {
    @StateObject var model: LeaderboardModel

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    HStack {
                        Text("leaderboard")
                            .font(.custom("LexendDeca-SemiBold", size: 20))
                        Text("👑")
                            .padding(.top, -3)
                    }
                    .padding(.top, 15)
                    LeaderboardList()
                        .environmentObject(model)
                        .listStyle(InsetListStyle())
                }
            }
        }
        .accentColor(Theme.Peach)
    }
}

struct LeaderboardList: View {
    @EnvironmentObject var model: LeaderboardModel
    @EnvironmentObject var currentUser: CurrentUserModel

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            List {
                ForEach(model.profiles.indices, id: \.self) { index in
                    LeaderboardListView(rank: (index + 1), profile: model.profiles[index])
                        .environmentObject(currentUser)
                    .listRowBackground(Theme.ScreenColor)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 18, leading: 10, bottom: 15, trailing: 10))
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

// struct LeaderboardPage_Previews: PreviewProvider {
//    static var previews: some View {
//        LeaderboardPage(model: LeaderboardModel())
//    }
//}


