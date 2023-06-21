//
//  SetProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct SetProfilePic: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text("upload a profile pic")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .padding(.top, 100)
                        
                        ProfilePictureView()
                            
                        Text("you're ready!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 20))
                        
                        LFButton(text: "finish"){}

                    }
                    .padding(.bottom, 300)
                    
                    
                }
            )
    }
}

struct SetProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        SetProfilePic()
    }
}
