//
//  EditPost.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/27/23.
//

import SwiftUI

struct EditPost: View {
    var post: String
    var prompt: String?

    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                ZStack {
                    PostAttributes(post: post, prompt: prompt)
                    
                    if prompt != nil {
                        Button(action: {
                            // open camera roll
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                                .frame(width: 350, height: 350)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .offset(x: 0, y: 23)
                        }
                    } else {
                        Button(action: {
                            // open camera roll
                        }) {
                            Image(systemName: "camera")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                                .frame(width: 350, height: 350)
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .offset(x: 0, y: 0)
                        }
                    }
                }
                
                Button(action: {
                    
                }) {
                    Text(prompt != nil ? "Change Prompt" : "Add Prompt")
                        .font(.custom("LexendDeca-Bold", size: 20))
                        .foregroundColor(Theme.Peach)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

struct EditPost_Previews: PreviewProvider {
    static var previews: some View {
        EditPost(post: "ragrboard")
    }
}

