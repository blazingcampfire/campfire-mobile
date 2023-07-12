//
//  FriendsPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI

struct FriendsPage: View {
    @State private var searchText = ""
    var body: some View {
            NavigationView {
                ListFriends()
                    .listStyle(PlainListStyle())
            }
            .searchable(text: $searchText)
            .background(Color.white)
            .padding(-10)
    }
}

struct ListFriends: View {
    
    let friendsList = [
        FriendsListView(profilepic: info.profilepic, name: info.name, username: info.username),
        FriendsListView(profilepic: "darsh", name: "Toni", username: "ton_bizzle"),
        FriendsListView(profilepic: "adarsh", name: "Adarsh", username: "geekslayer_21"),
    ]

    var body: some View {
        List {
            ForEach(0..<friendsList.count, id: \.self) { index in
                friendsList[index]
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage()
    }
}
