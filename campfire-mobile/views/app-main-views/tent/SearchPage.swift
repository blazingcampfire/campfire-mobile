//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State var searchText = ""
    @StateObject var model = SearchPageModel()
   
    var body: some View {
        NavigationView {
            SearchList()
                .environmentObject(model)
        }
        .searchable(text: $model.username)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct SearchList: View {
@EnvironmentObject var model: SearchPageModel
    let searchList = [
        SearchListView(profilepic: David.profilepic, name: David.name, username: David.username),
        SearchListView(profilepic: Toni.profilepic, name: Toni.name, username: Toni.username),
        SearchListView(profilepic: Adarsh.profilepic, name: Adarsh.name, username: Adarsh.username)
    ]
    
    @State private var addedTapped: Bool = false
    var body: some View {
        List {
            ForEach(model.profiles, id: \.self) { profile in
                SearchListView(profilepic: Toni.profilepic, name: profile.name ?? "LeMans", username: profile.username)
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
