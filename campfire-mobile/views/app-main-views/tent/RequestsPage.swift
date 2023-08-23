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
        if model.requests.isEmpty {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)

                VStack {
                    HStack {
                        VStack {
                            Text("requests")
                                .font(.custom("LexendDeca-SemiBold", size: 30))
                                .foregroundColor(Theme.TextColor)
                                .padding()
                        }
                        Spacer()
                    }
                    Spacer()
                    VStack {
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
                VStack {
                    HStack {
                        VStack {
                            Text("requests")
                                .font(.custom("LexendDeca-SemiBold", size: 30))
                                .foregroundColor(Theme.TextColor)
                                .padding()
                        }
                        Spacer()
                    }
                    ListRequests()
                        .environmentObject(model)
                }
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
