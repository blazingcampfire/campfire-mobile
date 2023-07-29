//
//  UserProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserProfilePic: View {
    
    let pfp: Data?
    
    var body: some View {
        if let pfp = pfp {
            Image(uiImage: UIImage(data: pfp)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125, height: 125)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Theme.PFPColor, lineWidth: 0.4)
                )
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125, height: 125)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Theme.PFPColor, lineWidth: 0.4)
                )
        }
    }
}

//struct UserProfilePic_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfilePic(pfp: David.profilepic)
//    }
//}
