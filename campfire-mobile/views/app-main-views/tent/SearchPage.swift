//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State private var viewHasAppeared: Bool = false
    @StateObject var model: SearchModel
    
    var body: some View {
        NavigationStack{
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                SearchList()
                    .environmentObject(model)
            }
            .searchable(text: $model.name, placement: .navigationBarDrawer)
        }
        .font(.custom("LexendDeca-SemiBold", size: 15))
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct SearchList: View {
    
    @EnvironmentObject var model: SearchModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            List {
                ForEach(model.profiles.indices, id: \.self) { index in
                    SearchListView(profile: model.profiles[index])
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
