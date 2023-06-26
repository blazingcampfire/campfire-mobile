//
//  userBio.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserBio: View {
    var name: String
    var text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .shadow(color: Color.pink, radius: 1)
            .frame(width: 300, height: 75)
            .overlay(
                Text(text)
                    .font(.custom("LexendDeca-Bold", size: 15))
                        .padding(8))
    }
}

struct UserBio_Previews: PreviewProvider {
    static var previews: some View {
        UserBio(name: "Adarsh", text: "wtw babygirl")
    }
}
