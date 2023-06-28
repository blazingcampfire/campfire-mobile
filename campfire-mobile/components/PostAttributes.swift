//
//  PostAttributes.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/26/23.
//

import SwiftUI



struct PostAttributes: View {
    var post: String
    var prompt: String?
    
    var body: some View {
        VStack(spacing: 1) {
            if let prompt = prompt {
                Rectangle()
                    .fill(Theme.Peach)
                    .frame(width: 350, height: 325 / 7)
                    .overlay(
                        Text(prompt)
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                    )
            }
            
            Image(post)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 350)
                .clipped()
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}




struct PostAttributes_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                PostAttributes(post: "ragrboard4", prompt: "for the dogs")
                    
                PostAttributes(post: "ragrboard5")
            }
        }
    }
}
