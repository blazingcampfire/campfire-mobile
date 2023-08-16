//
//  OtherProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 7/21/23.
//

import SwiftUI

struct OtherProfilePage: View {
    
    @State var settingsPageShow = false
    @StateObject var profileModel: ProfileModel
    @EnvironmentObject var currentUser: CurrentUserModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ZStack {
                            VStack {
                                VStack(spacing: 0) {
                                    if let profile = profileModel.profile {
                                        
                                        UserProfilePic(pfp: profileModel.profile?.profilePicURL)
                                        
                                        Spacer()
                                   
                                        Text((profile.name))
                                            .font(.custom("LexendDeca-Bold", size: 20))
                                        
                                        HStack {
                                            Text(profile.username)
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .foregroundColor(Theme.TextColor)
                                            HStack {
                                                Text("\(formatNumber(profile.smores))")
                                                    .font(.custom("LexendDeca-SemiBold", size: 15))
                                                Image("noteatensmore")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 18, height: 18)
                                                    .offset(x: -3)
                                            }
                                        }
                                        
                                        Text(profile.bio)
                                            .font(.custom("LexendDeca-Regular", size: 13))
                                            .padding(8)
                                    } else {
                                        Text("Bitch")
                                    }
                                }
                                .padding(.top)
                                HStack {
                                    // MARK: -  if user is looking at non-friends profile
                                    Button(action: {
                                        profileModel.requestFriend()
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
//
                                    
                                    NavigationLink(destination: FriendsPage(model: FriendsModel(currentUser: currentUser))) {
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
                        if let posts = profileModel.profile?.posts {
                            VStack(spacing: 20) {
                                Spacer()
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 60) {
                                    ForEach(posts, id: \.self) { post in
                                        if let (imageURL, prompt) = post.first {
                                            VStack(spacing: 20) {
                                                PostAttributes(url: imageURL, prompt: prompt)
                                                    .frame(width: 350)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Text("No posts yet.")
                        }

                    }
                }
                .padding()
        }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
            profileModel.getProfile()
        }
    }
}

//struct OtherProfilePage_Previews: PreviewProvider {
//    static var previews: some View {
//        OtherProfilePage()
//    }
//}
 
