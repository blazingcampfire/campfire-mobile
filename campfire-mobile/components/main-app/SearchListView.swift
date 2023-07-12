//
//  SearchList.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI

struct SearchListView: View {
    
    var profilepic: String
    var name: String
    var username: String
    @State private var addedTapped: Bool = false
    
    var body: some View {
        HStack {
            Image(profilepic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(name)
                    .font(.custom("LexendDeca-Bold", size: 18))
                    .foregroundColor(Theme.TextColor)
                Text("@\(username)")
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
    }
}

struct SearchListView_Previews: PreviewProvider {
    static var previews: some View {
       SearchListView(profilepic: info.profilepic, name: info.name, username: info.username)
    }
}


