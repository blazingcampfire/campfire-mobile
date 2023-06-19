//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

import SwiftUI

struct ProfilePage: View {
    let username: String = "JohnDoe"
    let profilePicture: String = "ragrboard"
    let postImages: [String] = [
        "ragrboard",
        "ragrboard",
        "ragrboard",
        "ragrboard"
    ]

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    Image(profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text(username)
                        .font(.title)
                    
                    Divider()
                    
                    Text("Recent Posts")
                        .font(.headline)
                        .padding(.top)
                    
                    List(postImages.prefix(6), id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .frame(height: 500)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            )
    }
}

struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}

