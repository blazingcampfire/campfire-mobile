//
//  ProfilePage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct ProfilePage: View {
    let username: String = "@david_adegangbanger"
    let profilePicture: String = "ragrboard"
    let bio: String = "Bio"
    let postImages: [String] = [
        "ragrboard",
        "ragrboard",
        "ragrboard",
        "ragrboard",
        "ragrboard",
        "ragrboard"
    ]

    var body: some View {
        VStack {
            
            Image(profilePicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())

            Text(username)
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.black)
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Theme.Apricot,
                        radius: 2)                .frame(height: 75)
                .overlay(Text(bio))

            Divider()
                .background(Theme.Peach)

            Text("Posts")
                .font(.custom("Futura-Bold", size: 15))
                .foregroundColor(.white)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10)], spacing: 60) {
                    ForEach(0..<postImages.count, id: \.self) { index in
                        VStack(spacing: 10) {
                            Image(postImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .shadow(color: Theme.Apricot, radius: 5)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 600)

            Spacer()
        }
        .padding()
    }
}




struct ProfilePage_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePage()
    }
}

