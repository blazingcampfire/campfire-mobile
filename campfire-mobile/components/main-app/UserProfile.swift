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

    var body: some View {
        VStack(spacing: 0) {
            UserProfilePic(pfp: "ragrboard")
            Spacer()

            if let profile = profileModel.profile {
                Text(profile.username) // Display the fetched username
                    .font(.custom("LexendDeca-Bold", size: 20))

                HStack {
                    Text(profile.username) // Display the fetched username again (just an example)
                        .font(.custom("LexendDeca-SemiBold", size: 15))
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(Theme.TextColor)
                    Text("\(profile.chocs)🍫") // Display the fetched number of chocs
                        .font(.custom("LexendDeca-SemiBold", size: 15))
                }

                Text("bio") // Display the fetched bio
                    .font(.custom("LexendDeca-Regular", size: 13))
                    .padding(8)
            } else {
                Text("Bitch")
            }
        }
        .onAppear {
            // Fetch the profile with ID "s8SB7xYlJ4hbja3B8ajsLY76nV63" when the view appears
            profileModel.getProfile(id: "s8SB7xYlJ4hbja3B8ajsLY76nV63")
        }
    }
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
