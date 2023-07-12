//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State var searchText = ""
    var body: some View {
        NavigationStack {
            // Text("Search for users") // users collection query
            FriendsList(range: 1 ... 12)
        }
        .searchable(text: $searchText)
        .background(Color.white)
        .listStyle(PlainListStyle())
        .padding(.top, -10)
    }
}

struct FriendsList: View {
    let range: ClosedRange<Int>
    @State private var addedTapped: Bool = false
    var body: some View {
        List {
            ForEach(range, id: \.self) { _ in
                HStack {
                    Image(info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(info.name)
                            .font(.custom("LexendDeca-Bold", size: 18))
                            .foregroundColor(Theme.TextColor)
                        Text("@\(info.username)")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button {
                        self.addedTapped.toggle()
                    } label: {
                        Image(systemName: self.addedTapped == false ? "plus.circle.fill" : "minus.circle.fill" )
                            .font(.system(size: 30))
                            .foregroundColor(Theme.Peach)
                    }
                }
                .listRowBackground(Theme.ScreenColor)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
