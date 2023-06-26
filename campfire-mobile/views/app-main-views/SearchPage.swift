//
//  SearchPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct SearchPage: View {
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
           // Text("Search for users") //users collection querey
            FriendsList(range: 1...12)
        }
        .searchable(text: $searchText)
    }
}

struct FriendsList: View {
    let range: ClosedRange<Int>
    
    var body: some View {
        List {
            ForEach(range, id: \.self) { number in
                HStack {
                    
                    Image(systemName: info.profilepic)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    
                    VStack(alignment: .leading) {
                        Text(info.name)
                            .bold()
                        Text("@\(info.username)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "plus.circle")
                        .font(.system(size: 30))
                        .foregroundColor(Theme.Peach)
                    
                    
                  //  Text("+")
                    //    .font(.custom("LexendDeca-Bold", size: 23))
                    
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}





struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
