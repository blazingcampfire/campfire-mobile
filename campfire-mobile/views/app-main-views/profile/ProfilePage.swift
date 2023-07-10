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
    
    @State var settingsPageShow = false
    
    
    var body: some View {
        
        NavigationView { // Wrap the content in a NavigationView
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ZStack {
                            VStack {
                                UserProfile()
                                    .padding(.top)
                                HStack {
                                    NavigationLink(destination: EditProfile()) { // use NavigationLink to navigate to the EditProfile view
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
                            Button(action: {
                                settingsPageShow.toggle()
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Theme.Peach)
                            }
                            .offset(x: 145, y: -130)
                            .sheet(isPresented: $settingsPageShow) {
                                SettingsPage()
                                    .presentationDragIndicator(.visible)
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
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}
