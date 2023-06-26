//
//  UserProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserProfilePic: View {
    var profilePic: String
    var username: String
    
    var body: some View {
        VStack {
            HStack {
                Image(profilePic)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.trailing)
                
                Text(username)
                    .font(.custom("LexendDeca-Bold", size: 15))
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
            }
            

        }
    }
}

struct UserProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePic(profilePic: "ragrboard", username: "david_adegangbanger")
    }
}
