//
//  EditProfile.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditProfile: View {
    @State private var david = UserInfo()
    @State var showPhotos: Bool = false
    @State var selectedImage: Image?
    

    var postImages: [[String]] = [
        ["ragrboard", "1"],
        ["ragrboard2"],
        ["ragrboard3", "3"],
        ["ragrboard4"],
        ["ragrboard5", "5"],
        ["ragrboard6"],
    ]

    var body: some View {
            ZStack {
                Theme.ScreenColor
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 10) {
                        ZStack {
                            UserProfilePic(pfp: David.profilepic )
                            
                            Button(action: {
                                showPhotos.toggle()
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 150)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .sheet(isPresented: $showPhotos) {
                                ImagePicker(selectedImage: $selectedImage, isPickerShowing: $showPhotos)
                            }
                        }
                        
                        Text("change profile pic")
                            .font(.custom("LexendDeca-Bold", size: 20))
                            .foregroundColor(Theme.Peach)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                Text(David.name)
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                Text(David.username)
                                    .font(.custom("LexendDeca-Bold", size: 15))
                                Text(David.bio)
                                    .font(.custom("LexendDeca-Bold", size: 15))
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 20) {
                                NavigationLink(destination: EditFieldPage(field: "name", currentfield: David.name)) {
                                    Text("edit name")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                                
                                NavigationLink(destination: EditFieldPage(field: "username", currentfield: David.username)) {
                                    Text("edit username")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                                
                                NavigationLink(destination: EditFieldPage(field: "bio", currentfield: David.bio)) {
                                    Text("edit bio")
                                        .font(.custom("LexendDeca-Bold", size: 15))
                                        .foregroundColor(Theme.Peach)
                                }
                            }
                            .padding(.trailing, 20)
                        }
                        
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20)], spacing: 30) {
                            ForEach(0..<postImages.count, id: \.self) { index in
                                VStack(spacing: 20) {
                                    ZStack(alignment: .topTrailing) {
                                        if postImages[index].count == 2 {
                                            PostAttributes(post: postImages[index][0], prompt: postImages[index][1], width: 300)
                                                .frame(width: 250)
                                        } else {
                                            PostAttributes(post: postImages[index][0], prompt: nil, width: 300)
                                                .frame(width: 250)
                                        }
                                        
                                        Circle()
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Circle()
                                                    .stroke(.gray, lineWidth: 0.5)
                                                    .frame(width: 50, height: 50)
                                            )
                                            .overlay(
                                                // need to include prompt in this
                                                NavigationLink(destination: EditPost(post: postImages[index][0])) {
                                                    Image(systemName: "pencil")
                                                        .font(.system(size: 30))
                                                        .foregroundColor(Theme.Peach)
                                                }
                                            )
                                            .padding(EdgeInsets(top: -10, leading: 10, bottom: 0, trailing: -40))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 30)
                    }
                    .padding(.vertical, 10)
                }
            }
        }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
