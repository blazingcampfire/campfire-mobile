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
    var bio: String
    var chocs: Int
    
    var body: some View {
        VStack {
            Image(profilePic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.gray, lineWidth: 0.3)
                )
                //.shadow(color: Theme.Peach, radius: 2, x: 0, y: 1)
            
            HStack {
                Text(username)
                    .font(.custom("LexendDeca-Bold", size: 15))
                
                Rectangle() // Centered Rectangle
                    .frame(width: 1, height: 30)
                    .foregroundColor(.gray)
                
                Text("🍫: " + String(chocs))
                    .font(.custom("LexendDeca-Bold", size: 15))
            }
            Text(bio)
                .font(.custom("LexendDeca-Bold", size: 13))
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
                                .shadow(color: .black, radius: 2, x: 0, y: 1)
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
                                .shadow(color: .black, radius: 2, x: 0, y: 1)
                        )
                }
                
                Button(action: {
                    // Go to Edit Profile
                }) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Theme.Peach)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .shadow(color: .black, radius: 2, x: 0, y: 1)
                        )
                }
            }
        }
    }
}



struct UserProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        UserProfilePic(profilePic: "ragrboard", username: "david_adegangbanger", bio: "wtw", chocs: 100)
    }
}

