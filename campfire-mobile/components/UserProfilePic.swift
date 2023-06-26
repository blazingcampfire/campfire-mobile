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
    var chocs: Int
    
    var body: some View {
        VStack {
            Image(profilePic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.trailing)
            
            HStack {
                Text(username)
                    .font(.custom("LexendDeca-Bold", size: 13))
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                
                Rectangle() // Must figure out how to center
                    .frame(width: 1, height: 35)
                    .foregroundColor(.black)
                
                Text("chocs : " + String(chocs))
                    .font(.custom("LexendDeca-Bold", size: 13))
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 20)
        }
    }
}


struct UserProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePic(profilePic: "ragrboard", username: "david_adegangbanger", chocs: 100)
    }
}

