//
//  RequestsListView.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/11/23.
//

import SwiftUI

struct RequestsListView: View {
    
    var profilepic: String = info.profilepic
    var profile: Profile
    
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
                    Text(profile.name)
                        .font(.custom("LexendDeca-Bold", size: 18))
                        .foregroundColor(Theme.TextColor)
                }

                Text("@\(profile.username)")
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.Peach)
                    .font(.custom("LexendDeca-Regular", size: 30))
            }
            Button(action: {
            }) {
                Image(systemName: "x.circle")
                    .foregroundColor(Theme.Peach)
                    .font(.custom("LexendDeca-Regular", size: 30))
            }
        }
    }
}

//struct RequestsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestsListView(profile: profile, info.profilepic)
//    }
//}
