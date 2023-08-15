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
                                if let profile = profileModel.profile {
                                    VStack(spacing: 0) {
                                        
                                        if profile.profilePicURL != "" {
                                            UserProfilePic(pfp: profileModel.profile?.profilePicURL)
                                        } else {
                                            FillerPFP()
                                        }
                                        
                                        Spacer()
                                        
                                        Text(profile.name)
                                            .font(.custom("LexendDeca-Bold", size: 20))
                                        
                                        HStack {
                                            Text(profile.username)
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .foregroundColor(Theme.TextColor)
                                            Text("\(formatNumber(profile.smores))🍫")
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                        }
                                        
                                        Text(profile.bio)
                                            .font(.custom("LexendDeca-Regular", size: 13))
                                            .padding(8)
                                        
                                    }
                                    .padding(.top)
                                    HStack {
                                        
                                        if (profileModel.requested) {
                                            Button(action: {
                                                profileModel.removeRequest()
                                            }) {
                                                Text("remove request")
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
                                        }
                                        else if (profileModel.friend) {
                                            Button(action: {
                                                profileModel.removeFriend()
                                            }) {
                                                Text("remove friend")
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
                                        }
                                        else {
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
                                        
                                        NavigationLink(destination: OtherFriendsPage(model: FriendsModel(currentUser: currentUser)
                                                                                     , userID: profile.userID)
                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                                            .navigationBarTitleDisplayMode(.inline)) {
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .navigationBarTitleDisplayMode(.inline)
    }
}

//struct OtherProfilePage_Previews: PreviewProvider {
//    static var previews: some View {
//        OtherProfilePage()
//    }
//}
 
