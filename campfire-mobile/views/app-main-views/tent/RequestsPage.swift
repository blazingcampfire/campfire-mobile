//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    @StateObject var model = RequestsPageModel(profiles: [], id: "M7vMoek6euPASORqzLSFbKq08ZI2")
    var body: some View {
        NavigationView {
            ListRequests()
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
    
    let requestList = [
        RequestsListView(profilepic: David.profilepic, name: David.name, username: David.username),
        RequestsListView(profilepic: Toni.profilepic, name: Toni.name, username: Toni.username),
        RequestsListView(profilepic: Adarsh.profilepic, name: Adarsh.name, username: Adarsh.username)
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
