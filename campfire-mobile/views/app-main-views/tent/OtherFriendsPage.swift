//
//  OtherFriendsPage.swift
//  campfire-mobile
//
//  Created by Toni on 8/13/23.
//

import SwiftUI

struct OtherFriendsPage: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var model: FriendsModel
    var userID: String
    var body: some View {
        
                if model.friends.isEmpty {
                    ZStack {
                        Theme.ScreenColor
                            .ignoresSafeArea(.all)
                        
                        VStack {
                            HStack {
                                VStack {
                                    Text("friends")
                                        .font(.custom("LexendDeca-SemiBold", size: 30))
                                        .foregroundColor(Theme.TextColor)
                                        .padding()
                                }
                                Spacer()
                                
                            }
                            Spacer()
                            VStack {
                                
                                Text("no friends yet!")
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                    .foregroundColor(Theme.TextColor)
                            }
                            Spacer()
                        }
                    }
                    .background(Color.white)
                    .padding(-10)
                    
                }
                else {
                    ZStack {
                        Theme.ScreenColor
                            .ignoresSafeArea(.all)
                        VStack {
                            HStack {
                                VStack {
                                    Text("friends")
                                        .font(.custom("LexendDeca-SemiBold", size: 30))
                                        .foregroundColor(Theme.TextColor)
                                        .padding()
                                }
                                Spacer()
                                
                            }
                            
                            ListOtherFriends()
                        }
                    }
                    .background(Color.white)
                    .padding(-10)
                    .onAppear {
                        model.readOtherFriends(userID: userID)
                    }
                    .environmentObject(model)
                }
    }
}

struct ListOtherFriends: View {
    
    @EnvironmentObject var model: FriendsModel
    
    var body: some View {
        List {
            ForEach(model.friends, id: \.self) { request in
                OtherFriendsListView(request: request)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

