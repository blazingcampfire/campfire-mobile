//
//  LeaderboardPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditProfile: View {
    @State private var isEditingName = false
    @State private var editedName = "David"
    
    @State private var isEditingBio = false
    @State private var editedBio = "tell ya moms to watch out ya heard"
    
    var userInfo = UserInfo(name: "David", username: "@david_adegangbanger", profilepic: "ragrboard", marshcount: 100)
    var userProfile: UserProfile
    
    let postImages: [[String]] = [
        ["ragrboard", "1"],
        ["ragrboard2"],
        ["ragrboard3", "3"],
        ["ragrboard4"],
        ["ragrboard5", "5"],
        ["ragrboard6"]
    ] //url strings in firebase
    
    init() {
        userProfile = UserProfile(profilePic: userInfo.profilepic, name: userInfo.name, username: userInfo.username, bio: "io", chocs: userInfo.marshcount)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(spacing: 20) {
                    Image(userProfile.profilePic)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        if isEditingName {
                            TextField("Name", text: $editedName)
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    HStack {
                                        Button(action: {
                                            // Cancel name changes
                                            editedName = userInfo.name
                                            isEditingName.toggle()
                                        }) {
                                            Text("Cancel")
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                .foregroundColor(.red)
                                                .padding(.horizontal)
                                        }
                                        Spacer()
                                        Button(action: {
                                            // Save name changes
                                            isEditingName.toggle()
                                        }) {
                                            Text("Done")
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                .foregroundColor(.green)
                                                .padding(.horizontal)
                                        }
                                    }
                                )
                        } else {
                            Text(editedName)
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .padding(.horizontal)
                        }
                        
                        HStack {
                            Text(userInfo.username)
                                .font(.custom("LexendDeca-SemiBold", size: 15))
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundColor(.black)
                            Text("\(userInfo.marshcount)🍫")
                                .font(.custom("LexendDeca-SemiBold", size: 15))
                        }
                        
                        if isEditingBio {
                            TextField("Bio", text: $editedBio)
                                .font(.custom("LexendDeca-Regular", size: 13))
                                .padding(.horizontal)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .overlay(
                                    HStack {
                                        Button(action: {
                                            // Cancel bio changes
                                            isEditingBio.toggle()
                                        }) {
                                            Text("Cancel")
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                .foregroundColor(.red)
                                                .padding(.horizontal)
                                        }
                                        Spacer()
                                        Button(action: {
                                            // Save bio changes
                                            isEditingBio.toggle()
                                        }) {
                                            Text("Done")
                                                .font(.custom("LexendDeca-Bold", size: 15))
                                                .foregroundColor(.green)
                                                .padding(.horizontal)
                                        }
                                    }
                                )
                        } else {
                            Text(editedBio)
                                .font(.custom("LexendDeca-Regular", size: 13))
                                .padding(.horizontal)
                        }
                        
                        HStack {
                            Button(action: {
                                isEditingName.toggle()
                            }) {
                                Text(isEditingName ? "Cancel" : "Edit Name")
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
                            
                            Button(action: {
                                isEditingBio.toggle()
                            }) {
                                Text(isEditingBio ? "Cancel" : "Edit Bio")
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
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}



struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile()
    }
}
