//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    @StateObject var model: RequestsPageModel
    var body: some View {
        NavigationView {
            ListRequests()
                .environmentObject(model)
        }
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
        .onAppear { 
            model.readRequests()
        }
    }
}

struct ListRequests: View {
    @EnvironmentObject var model: RequestsPageModel
    
    var body: some View {
        List {
            ForEach(model.profiles, id: \.self) { profile in
                RequestsListView(profile: profile)
                    .environmentObject(model)
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
