//
//  RequestsPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/3/23.

import SwiftUI

struct RequestsPage: View {
    @StateObject var model: RequestsModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            if model.requests.isEmpty {
                ZStack {
                    Theme.ScreenColor
                        .ignoresSafeArea(.all)

                    VStack {
                        VStack {
                            Text("requests")
                                .font(.custom("LexendDeca-SemiBold", size: 30))
                                .foregroundColor(Theme.TextColor)
                                .padding(.leading, 15)
                                .frame(alignment: .leading)
                        }
                        Spacer()
                        VStack {
                            Image(systemName: "person.fill.badge.plus")
                                .font(.system(size: 30))
                                .foregroundColor(Theme.Peach)
                                .padding(.bottom, 30)

                            Text("no requests right now!")
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .foregroundColor(Theme.TextColor)
                        }
                        Spacer()
                    }
                }
                .background(Color.white)
                .padding(-10)
            } else {
                ZStack {
                    Theme.ScreenColor
                        .ignoresSafeArea(.all)

                    ListRequests()
                        .environmentObject(model)
                }
                .refreshable {
                    model.readRequests()
                }
                .background(Color.white)
                .listStyle(PlainListStyle())
                .padding(.top, -10)
            }
        }
    
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

// struct RequestsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestsPage()
//    }
// }
