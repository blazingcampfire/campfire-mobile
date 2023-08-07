//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    
    @StateObject var model: SearchModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                SearchList()
                    .environmentObject(model)
            }
        }
        .searchable(text: $model.name)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct SearchList: View {
    
@EnvironmentObject var model: SearchModel
    
    @State private var addedTapped: Bool = false
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            List {
                ForEach(model.profiles, id: \.self) { profile in
                    SearchListView(profile: profile)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Theme.ScreenColor)
            }
            .listStyle(PlainListStyle())
        }
    }
}

//struct SearchPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchPage()
//    }
//}
