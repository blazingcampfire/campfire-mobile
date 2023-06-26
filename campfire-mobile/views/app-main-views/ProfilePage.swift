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
    
    let postImages: [[String]] = [
        ["ragrboard", "dawg moment"],
        ["ragrboard2", " my yale moment: "],
        ["ragrboard3", " weekend outing "],
        ["ragrboard4", " favorite study spot"],
        ["ragrboard5", " frat moment" ],
        ["ragrboard6", " my party face"]
    ] //url strings in firebase

    init() {
        userProfilePic = UserProfilePic(profilePic: userInfo.profilepic, username: userInfo.username, chocs: userInfo.marshcount)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                
                userProfilePic
                    .padding(.top)
                
                Spacer()
                Spacer()
               
                
                UserBio(name: userInfo.name, text: "tell ya moms to watch out ya heard")
                
                Spacer()
                Divider()
                Spacer()
                Spacer()
                
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 30)], spacing: 60) {
                    ForEach(0..<postImages.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            PostAttributes(post: postImages[index][0], prompt:postImages[index][1] )
                                .clipShape(RoundedRectangle(cornerRadius: 30))
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

