//
//  PostAttributes.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/26/23.
//

import SwiftUI



struct PostAttributes: View {
    var post: String
    var prompt: String
    
    var body: some View {
        VStack(spacing: 1) {
            Rectangle()
                .fill(Theme.Apricot)
                .frame(height: 325 / 7)
                .overlay(
                    Text(prompt)
                        .foregroundColor(.black)
                        .font(.custom("LexendDeca-Bold", size: 15))
                )
            
            Image(post)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .shadow(color: Theme.Apricot, radius: 2)
        }
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}



struct PostAttributes_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                PostAttributes(post: "ragrboard4", prompt: "for the dogs")
                    
                PostAttributes(post: "ragrboard5", prompt: "for the bitches")
            }
        }
    }
}
