//
//  FriendsPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI

struct FriendsPage: View {
    
    @StateObject var model: FriendsModel
    
    var body: some View {
            NavigationView {
                ListFriends()
                    .environmentObject(model)
                    .listStyle(PlainListStyle())
            }
            .background(Color.white)
            .padding(-10)
    }
}

struct ListFriends: View {
    
    @EnvironmentObject var model: FriendsModel
    
    var body: some View {
        List {
            ForEach(model.friends, id: \.self) { request in
                FriendsListView(profilepic: info.profilepic, request: request)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

//struct FriendsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsPage()
//    }
//}
