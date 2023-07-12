//
//  FriendsListView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI

struct FriendsListView: View {
    
    var profilepic: String
    var name: String
    var username: String
    
    var body: some View {
        HStack {
            // user image is passed in
            Image(profilepic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Button(action: {
                }) {
                    Text(name)
                        .font(.custom("LexendDeca-Bold", size: 18))
                        .foregroundColor(Theme.TextColor)
                }

                Text("@\(username)")
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView(profilepic: info.profilepic, name: info.name, username: info.username)
    }
}


