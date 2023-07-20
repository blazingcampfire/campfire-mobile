//
//  UserProfile.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI
import FirebaseFirestore

struct UserProfile: View {
    
    @StateObject var profileModel = ProfileModel()
    
    var userID = "Adarsh"
    
    init(userID: String) {
        self.profileModel.userID = userID
        self.profileModel.fetchProfileData()
    }
    
    


    var body: some View {
        VStack(spacing: 0) {
            
            UserProfilePic(pfp: "ragrboard")
            Spacer()
            if let profile = self.profileModel.profileData {
                
                Text(profile.name!)
                    .font(.custom("LexendDeca-Bold", size: 20))
                
                HStack {
                    Text(profile.username)
                        .font(.custom("LexendDeca-SemiBold", size: 15))
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(Theme.TextColor)
                    Text(String(profile.chocs) + "🍫")
                        .font(.custom("LexendDeca-SemiBold", size: 15))
                }
                Text(profile.bio)
                    .font(.custom("LexendDeca-Regular", size: 13))
                    .padding(8)
            }
            else {
                Text("loading")
            }
            
//            HStack {
//                Button(action: {
//                    // Go to Edit Profile
//                }) {
//                    Text("Edit Profile") //conditional visibility, if viewing another user, show Add Friend instead
//                        .font(.custom("LexendDeca-Bold", size: 15))
//                        .foregroundColor(Theme.Peach)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.black, lineWidth: 0.3)
//                                )
//                        )
//                }
//
//                Button(action: {
//                    // Go to Edit Profile
//                }) {
//                    Image(systemName: "person.3.fill")
//                        .font(.system(size: 20))
//                        .foregroundColor(Theme.Peach)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .fill(.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.black, lineWidth: 0.3)
//
//                                )
//                        )
//                }
//            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(userID: "Adarsh")
    }
}
