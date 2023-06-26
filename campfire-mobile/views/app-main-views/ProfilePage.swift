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
        userProfilePic = UserProfilePic(profilePic: userInfo.profilepic, username: userInfo.username, bio: "tell ya moms to watch out ya heard", chocs: userInfo.marshcount)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                ZStack {
                    userProfilePic
                        .padding(.top)
                    Button (action: {
                       // print("yayd")
                    })
                    {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 35))
                            .offset(x:145, y: -80)
                            .foregroundColor(Theme.Apricot)
                    }
                    
                }
                
                VStack(spacing: 20) { // Added spacing between elements
                  //  userProfilePic
                    
                    Divider()
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 60) {
                        ForEach(0..<postImages.count, id: \.self) { index in
                            VStack(spacing: 20) {
                                PostAttributes(post: postImages[index][0], prompt: postImages[index][1])
                                    .frame(width: 275)
                                    .shadow(color: Theme.Apricot, radius: 3, x: 0, y: 2)
                            }
                        }
                    }
                }
                .padding(.horizontal) // Added horizontal padding to the VStack
            }
            .padding() // Added padding to the outer ScrollView
        }
    }
}
    
    struct ProfilePage_Previews: PreviewProvider {
        static var previews: some View {
            ProfilePage()
        }
    }
    

