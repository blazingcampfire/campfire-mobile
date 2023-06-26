//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct ProfilePage: View {
    var userInfo = UserInfo(name: "David", username: "david_adegangbanger", profilepic: "ragrboard", marshcount: 100)
    var userProfilePic: UserProfilePic
    
    let postImages: [String] = [
        "ragrboard",
        "ragrboard2",
        "ragrboard3",
        "ragrboard4",
        "ragrboard5",
        "ragrboard6"
    ] //url strings in firebase

    init() {
        userProfilePic = UserProfilePic(profilePic: userInfo.profilepic, username: userInfo.username)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                
                userProfilePic
                    .padding(.top)
                
                Spacer()
                Spacer()
               
                
                UserBio(name: userInfo.name, text: "tell ya moms to watch out ya heard", chocs: userInfo.marshcount)
                
                Spacer()
                Spacer()
                Spacer()
                
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 60) {
                    ForEach(0..<postImages.count, id: \.self) { index in
                        VStack(spacing: 10) {
                            Image(postImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(color: Theme.Apricot, radius: 2)
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}



struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}

