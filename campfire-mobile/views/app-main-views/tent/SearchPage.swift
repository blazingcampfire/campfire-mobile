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
        .searchable(text: $model.name)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct SearchList: View {
@EnvironmentObject var model: SearchPageModel
    
    
    @State private var addedTapped: Bool = false
    var body: some View {
        List {
            ForEach(model.profiles, id: \.self) { profile in
                SearchListView(profilepic: Toni.profilepic, name: profile.name, username: profile.username)
                    .environmentObject(model)
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
