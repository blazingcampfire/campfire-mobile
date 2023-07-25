//
//  OtherProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/21/23.
//

import SwiftUI

struct OtherProfilePage: View {
    
    let postImages: [[String]] = [
//        ["ragrboard", "1"],
//        ["ragrboard2"],
//        ["ragrboard3", "3"],
//        ["ragrboard4"],
//        ["ragrboard5", "5"],
//        ["ragrboard6"]
    ] //url strings in firebase
 
    @StateObject var profileModel = ProfileModel(id: "s8SB7xYlJ4hbja3B8ajsLY76nV63")

    
    
    var body: some View {
        
        NavigationView { // Wrap the content in a NavigationView
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ZStack {
                            VStack {
                                VStack(spacing: 0) {
                                    UserProfilePic(pfp: "ragrboard")
                                    Spacer()

                                    if let profile = profileModel.profile {
                                        Text(profile.name) // display the fetched username
                                            .font(.custom("LexendDeca-Bold", size: 20))

                                        HStack {
                                            Text(profile.username)
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .foregroundColor(Theme.TextColor)
                                            Text("\(profile.chocs)🍫") // display the fetched number of chocs
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                        }

                                        Text(profile.bio)
                                            .font(.custom("LexendDeca-Regular", size: 13))
                                            .padding(8)
                                    } else {
                                        Text("Error")
                                    }
                                }
                                    .padding(.top)
                                HStack {
    
                                    // MARK: -  if user is looking at a non friend's profile
                                    
                                  
                                    Button(action: {
//                                   SEND FRIEND REQUEST TO USER OF THE VIEWING PROFILE
                                    }) {
                                        Text("add friend!")
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
                                    // MARK: -  if user is looking at friends profile
//
//                                    Button(action: {
///                                       SEND ALERT TO UNFRIEND
//                                     }) {
//                                        Text("Friends")
//                                            .font(.custom("LexendDeca-Bold", size: 15))
//                                            .foregroundColor(Theme.Peach)
//                                            .padding()
//                                            .background(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .fill(.white)
//                                                    .overlay(
//                                                        RoundedRectangle(cornerRadius: 10)
//                                                            .stroke(Color.black, lineWidth: 0.3)
//                                                    )
//                                            )
//                                    }
                                    
                                    
                                    
                                    NavigationLink(destination: FriendsPage()){
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
        .onAppear {
            profileModel.getProfile()
        }
    }
}

struct OtherProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        OtherProfilePage()
    }
}
