//
//  UserProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserProfilePic: View {
    var profilePic: String
    
    var body: some View {
        Image(profilePic)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.gray, lineWidth: 0.3)
                )
    }
}

struct UserProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePic(profilePic: "ragrboard")
    }
}
