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
    @State private var showAddPost = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack {
                            ZStack {
                                VStack {
                                    VStack(spacing: 0) {
                                        if let profile = profileModel.profile {
                                            
                                            UserProfilePic(pfp: profileModel.profile?.profilePicURL)
                                            
                                            Spacer()
                                            
                                            Text(profile.name)
                                                .font(.custom("LexendDeca-Bold", size: 20))
                                            
                                            HStack {
                                                Text(profile.username)
                                                    .font(.custom("LexendDeca-SemiBold", size: 15))
                                                Circle()
                                                    .frame(width: 4, height: 4)
                                                    .foregroundColor(Theme.TextColor)
                                                Text("\(profile.smores)🍫")
                                                    .font(.custom("LexendDeca-SemiBold", size: 15))
                                            }
                                            
                                            Text(profile.bio)
                                                .font(.custom("LexendDeca-Regular", size: 13))
                                                .padding(8)
                                        } else {
                                            Text("chill out")
                                        }
                                    }
                                    .padding(.top)
                                    HStack {
                                        NavigationLink(destination: EditProfile()
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
                        }
                        .padding(.bottom, 40)
                        
                        if let posts = profileModel.profile?.posts {
                            VStack {
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
                                if posts.count < 6 {
                                    Spacer()
                                    NavigationLink(destination: AddPost(showAddPost: $showAddPost).environmentObject(profileModel)) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 350, height: 350)
                                            VStack {
                                                Image(systemName: "plus.circle")
                                                    .font(.system(size: 75))
                                                    .foregroundColor(Theme.Peach)
                                                Text("add post!")
                                                    .font(.custom("LexendDeca-SemiBold", size: 25))
                                                    .foregroundColor(Theme.Peach)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    profileModel.getProfile()
                }
            }
            .onAppear {
                    profileModel.getProfile()

            }
        }
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        OwnProfilePage()
    }
}
