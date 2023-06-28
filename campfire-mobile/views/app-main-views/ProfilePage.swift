//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct ProfilePage: View {
    let userInfo = UserInfo()
    
    
    let postImages: [[String]] = [
        ["ragrboard", "1"],
        ["ragrboard2"],
        ["ragrboard3", "3"],
        ["ragrboard4"],
        ["ragrboard5", "5"],
        ["ragrboard6"]
    ] //url strings in firebase
    
  //  init() {
    //    userProfile = UserProfile(profilePic: userInfo.profilepic, name: userInfo.name, username: userInfo.username, bio: "tell ya moms to watch out ya heard", chocs: userInfo.marshcount)
 //   }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                ZStack {
                    UserProfile()
                        .padding(.top)
                    Button(action: {
                        // Go to Edit Profile
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 30))
                            .foregroundColor(Theme.Peach)
                    }
                    .offset(x: 145, y: -120)
                }
                
                VStack(spacing: 20) { // Added spacing between elements
                    
                    Spacer()
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 60) {
                        ForEach(0..<postImages.count, id: \.self) { index in
                            VStack(spacing: 20) {
                                if postImages[index].count == 2 {
                                    PostAttributes(post: postImages[index][0], prompt: postImages[index][1])
                                        .frame(width: 350)
                                } else {
                                    PostAttributes(post: postImages[index][0], prompt: nil)
                                        .frame(width: 350)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
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

