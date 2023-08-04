//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    
    @StateObject var model: RequestsModel
    
    var body: some View {
        NavigationView {
            ListRequests()
                .environmentObject(model)
        }
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct ListRequests: View {
    @EnvironmentObject var model: RequestsModel
    
    let friendsList = [
        FriendsListView(profilepic: David.profilepic, name: David.name, username: David.username),
        FriendsListView(profilepic: Toni.profilepic, name: Toni.name, username: Toni.username),
        FriendsListView(profilepic: Adarsh.profilepic, name: Adarsh.name, username: Adarsh.username)
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

//struct RequestsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestsPage()
//    }
//}
