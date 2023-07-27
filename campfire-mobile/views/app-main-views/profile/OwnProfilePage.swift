//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct OwnProfilePage: View {
    @State var settingsPageShow = false
    @StateObject var profileModel = ProfileModel(id: "s8SB7xYlJ4hbja3B8ajsLY76nV63")
    
    var body: some View {
        NavigationView {
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
                                        Text(profile.name)
                                            .font(.custom("LexendDeca-Bold", size: 20))
                                        
                                        HStack {
                                            Text(profile.username)
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
                                            Circle()
                                                .frame(width: 4, height: 4)
                                                .foregroundColor(Theme.TextColor)
                                            Text("\(profile.chocs)🍫")
                                                .font(.custom("LexendDeca-SemiBold", size: 15))
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
                                    NavigationLink(destination: EditProfile(postImages: profileModel.profile?.postData ?? [], prompts: profileModel.profile?.prompts ?? [])
                                        .environmentObject(profileModel)) {
                                            Text("Edit Profile")
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
                                    
                                    NavigationLink(destination: FriendsPage()) {
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
                            Button(action: {
                                settingsPageShow.toggle()
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Theme.Peach)
                            }
                            .offset(x: 155, y: -140)
                            .sheet(isPresented: $settingsPageShow) {
                                SettingsPage()
                                    .presentationDragIndicator(.visible)
                                    .presentationCornerRadius(30)
                            }
                        }
                        if let posts = profileModel.profile?.postData {
                            
                            VStack {
                                VStack(spacing: 20) {
                                    Spacer()
                                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 60) {
                                        ForEach(posts, id: \.self) { post in
                                            if let imageData = post as? Data {
                                                VStack(spacing: 20) {
                                                    PostAttributes(data: imageData)
                                                        .frame(width: 350)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                profileModel.getProfile()
                if let postData = profileModel.profile?.postData {
                    print("postData onAppear: \(postData)")
                } else {
                    print("postData onAppear is nil or empty.")
                }
            }
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        OwnProfilePage()
    }
}
