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
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ListRequests()
                    .environmentObject(model)
            }
        }
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct ListRequests: View {
    
    @EnvironmentObject var model: RequestsModel
    
    var body: some View {
        List {
            ForEach(model.requests, id: \.self) { request in
                RequestsListView(request: request)
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
