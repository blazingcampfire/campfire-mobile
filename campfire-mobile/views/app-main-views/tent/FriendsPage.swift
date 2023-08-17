//
//  FriendsPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI

struct FriendsPage: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var model: FriendsModel
    
    var body: some View {
    
                if model.friends.isEmpty {
                    ZStack {
                        Theme.ScreenColor
                            .ignoresSafeArea(.all)
                        
                        VStack {
                            VStack {
                                Text("Friends")
                                    .font(.custom("LexendDeca-SemiBold", size: 30))
                                    .foregroundColor(Theme.TextColor)
                                    .padding(.leading, 15)
                            }
                            Spacer()
                            VStack {
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(Theme.Peach)
                                    .padding(.bottom, 30)
                                
                                Text("go make some friends!")
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
                        
                        ListFriends()
                    }
                    .environmentObject(model)
                    .background(Color.white)
                    .padding(-10)
                }
            
    }
}

struct ListFriends: View {
    
    @EnvironmentObject var model: FriendsModel
    
    var body: some View {
        List {
            ForEach(model.friends, id: \.self) { request in
                FriendsListView(request: request)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Theme.ScreenColor)
        }
        .listStyle(PlainListStyle())
    }
}

//struct FriendsPage_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsPage()
//    }
//}
