//
//  UserProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserProfilePic: View {
    let userinfo = UserInfo()
    
    var body: some View {
        Image(userinfo.profilepic)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Theme.PFPColor, lineWidth: 0.4)
                )
    }
}

struct UserProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePic()
    }
}
