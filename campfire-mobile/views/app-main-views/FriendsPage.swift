//
//  FriendsPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI

struct FriendsPage: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ListFriends(range: 1...12)
            .navigationTitle("Friends")
            .font(.custom("LexendDeca-Bold", size: 25))
            .listStyle(PlainListStyle())
        }
        .searchable(text: $searchText)
        .background(Color.white)
    }
}

struct ListFriends: View {
    let range: ClosedRange<Int>
    
    var body: some View {
        List {
            ForEach(range, id: \.self) { number in
                HStack {
                    
                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    
                    VStack(alignment: .leading) {
                        Button(action: {
                        }) {
                            Text(info.name)
                                .font(.custom("LexendDeca-Bold", size: 18))
                                .foregroundColor(.black)
                        }
                        
                        Text("@\(info.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Color.white)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
    }
}




struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage()
    }
}
