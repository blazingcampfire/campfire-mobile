//
//  UserProfile.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct UserProfile: View {
    var profilePic: String
    var name: String
    var username: String
    var bio: String
    var chocs: Int
    
    var body: some View {
        VStack(spacing: 0) {
            UserProfilePic(profilePic: profilePic)
            Spacer()
            Text(name)
                .font(.custom("LexendDeca-Bold", size: 20))
            
            HStack {
                Text(username)
                    .font(.custom("LexendDeca-SemiBold", size: 15))
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundColor(.black)
                Text(String(chocs) + "🍫")
                    .font(.custom("LexendDeca-SemiBold", size: 15))
            }
            Text(bio)
                .font(.custom("LexendDeca-Regular", size: 13))
                .padding(8)
            
            HStack {
                Button(action: {
                    // Go to Edit Profile
                }) {
                    Text("Edit Profile")
                        .font(.custom("LexendDeca-Bold", size: 15))
                        .foregroundColor(Theme.Peach)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0.3)
                                )
                        )
                }
                
                Button(action: {
                    // Go to Edit Profile
                }) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.Peach)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0.3)
                                        
                                )
                        )
                }
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(profilePic: "ragrboard", name: "David", username: "david_adegangbanger", bio: "woah bwhwhwhhwhsssssssssswhhwhwhwhwh", chocs: 100)
    }
}
