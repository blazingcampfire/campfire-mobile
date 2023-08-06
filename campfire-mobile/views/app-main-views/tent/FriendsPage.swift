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
            NavigationView {
                if model.friends.isEmpty {
                    VStack {
                        VStack {
                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    BackButton(color: Theme.Peach)
                                }
                            }
                            .padding(.bottom, 10)
                            
                            Text("friends")
                                .font(.custom("LexendDeca-SemiBold", size: 30))
                                .foregroundColor(Theme.TextColor)
                                .padding(.leading, 15)
                        }
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .topLeading)
                        
                        VStack {
                            Image(systemName: "person.fill.badge.plus")
                                .font(.system(size: 30))
                                .foregroundColor(Theme.Peach)
                                .padding(.bottom, 30)
                            
                            Text("go make some friends!")
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .foregroundColor(Theme.TextColor)
                            Spacer()
                        }
                     
                    }
                    
                }
                else {
                    ListFriends()
                    .environmentObject(model)
                    .listStyle(PlainListStyle())
                    .navigationBarBackButtonHidden(true)
                }
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.white)
            .padding(-10)
    }
}

struct ListFriends: View {
    
    @EnvironmentObject var model: FriendsModel
    
    var body: some View {
        List {
            ForEach(model.friends, id: \.self) { request in
                FriendsListView(profilepic: info.profilepic, request: request)
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
