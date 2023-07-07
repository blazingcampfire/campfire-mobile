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
    var width: CGFloat? = 350
    
    var body: some View {
        VStack(spacing: 1) {
            if let prompt = prompt {
                Rectangle()
                    .fill(Theme.Peach)
                    .frame(width: width, height: 325 / 7)
                    .overlay(
                        Text(prompt)
                            .foregroundColor(.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                    )
            }
            
            Image(post)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: width)
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
                    
                PostAttributes(post: "ragrboard5", width: 350)
            }
        }
    }
}