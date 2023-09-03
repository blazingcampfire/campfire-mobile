//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct OwnProfilePage: View {
    @EnvironmentObject var currentUser: CurrentUserModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    @State var settingsPageShow = false
    @State private var showAddPost = false
    @AppStorage("isDarkMode") private var darkMode = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    let posts = currentUser.profile.posts
                    VStack {
                        VStack {
                            ZStack {
                                VStack {
                                    VStack(spacing: 0) {
                                        let profile = currentUser.profile

                                        if profile.profilePicURL != "" {
                                            UserProfilePic(pfp: profile.profilePicURL)
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
                                            .multilineTextAlignment(.center)
                                            .padding(8)
                                    }
                                    .padding(.top)
                                    HStack {
                                        NavigationLink(destination: EditProfile()
                                            .environmentObject(currentUser)) {
                                                Text("edit profile")
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

                                        NavigationLink(destination: FriendsPage(model: FriendsModel(currentUser: currentUser)))
                                            {
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
                                        NavigationLink(destination: RequestsPage(model: RequestsModel(currentUser: currentUser))) {
                                            Text("requests")
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
                                }
                                NavigationLink(destination: SettingsPage(darkMode: $darkMode, model: SettingsModel(currentUser: currentUser, notificationsOn: notificationsManager.hasPermission, notificationsManager: notificationsManager))
                                    .toolbar(.hidden, for: .tabBar)
                                ) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(Theme.Peach)
                                }
                                .offset(x: 155, y: -140)
                            }
                        }

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
                            .safeAreaInset(edge: .bottom) {
                                if posts.count < 6 {
                                    NavigationLink(destination: AddPost(showAddPost: $showAddPost).environmentObject(currentUser)) {
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.clear)
                                                .frame(width: 350, height: 350)
                                            VStack {
                                                Image(systemName: "plus.circle")
                                                    .font(.system(size: 100))
                                                    .foregroundColor(Theme.Peach)
                                                Text("add flick!")
                                                    .font(.custom("LexendDeca-SemiBold", size: 25))
                                                    .foregroundColor(Theme.Peach)
                                                Text("(max 6)")
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
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
