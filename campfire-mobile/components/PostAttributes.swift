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
                .frame(width: 250, height: 250 / 7)
                .overlay(
                    Text(prompt)
                        .foregroundColor(.black)
                        .font(.custom("LexendDeca-Bold", size: 15))
                )
            
            Image(post)
                .resizable()
                .aspectRatio(contentMode: .fill)  
                .frame(width: 250, height: 250)
                .clipped()
                .shadow(color: Theme.Apricot, radius: 2)
        }
    }
}



struct PostAttributes_Previews: PreviewProvider {
    static var previews: some View {
        PostAttributes(post: "ragrboard", prompt: "for the dogs")
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .frame(height: 200)
    
    }
}
