//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            // Text("Search for users") // users collection query
            SearchList()
        }
        .searchable(text: $searchText)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct SearchList: View {
    let searchList = [
        SearchListView(profilepic: info.profilepic, name: info.name, username: info.username),
        SearchListView(profilepic: "darsh", name: "Toni", username: "ton_bizzle"),
        SearchListView(profilepic: "adarsh", name: "Adarsh", username: "geekslayer_21")
    ]
    
    @State private var addedTapped: Bool = false
    var body: some View {
        List {
            ForEach(0..<searchList.count, id: \.self) { index in
                searchList[index]
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
