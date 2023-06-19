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
    let postImages: [String] = [
        "ragrboard",
        "ragrboard",
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
                        .font(.custom("Futura-Bold", size: 20))
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.white)
                    
                    Text("Posts")
                        .font(.custom("Futura-Bold", size: 15))
                        .foregroundColor(.white)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            ForEach(0..<postImages.count, id: \.self) { index in
                                if index % 2 == 0 {
                                    VStack(spacing: 10) {
                                        Image(postImages[index])
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        
                                        if index + 1 < postImages.count {
                                            Image(postImages[index + 1])
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 500)
                    
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

