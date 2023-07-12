//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            // Text("Search for users") // users collection query
            ListRequests()
        }
        .searchable(text: $searchText)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct ListRequests: View {
    
    let requestList = [
        RequestsListView(profilepic: info.profilepic, name: info.name, username: info.username),
        RequestsListView(profilepic: "darsh", name: "Toni", username: "ton_bizzle"),
        RequestsListView(profilepic: "adarsh", name: "Adarsh", username: "geekslayer_21")
    ]
    
    var body: some View {
        List {
            ForEach(0..<requestList.count, id: \.self) { index in
                requestList[index]
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

struct RequestsPage_Previews: PreviewProvider {
    static var previews: some View {
        RequestsPage()
    }
}
