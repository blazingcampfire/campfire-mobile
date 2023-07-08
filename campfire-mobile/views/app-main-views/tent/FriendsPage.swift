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
                    .listStyle(PlainListStyle())
            }
            .searchable(text: $searchText)
            .background(Color.white)
            .padding(-10)
    }
}

struct ListFriends: View {
    let range: ClosedRange<Int>

    var body: some View {
        List {
            ForEach(range, id: \.self) { _ in
                HStack {
                    // user image is passed in
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
                                .foregroundColor(Theme.TextColor)
                        }

                        Text("@\(info.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .listRowBackground(Theme.ScreenColor)
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
