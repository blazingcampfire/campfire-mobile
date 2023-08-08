//
//  userBio.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/25/23.
//

import SwiftUI

struct UserBio: View {
    var name: String
    var bio: String

    var body: some View {
        Text(bio)
            .font(.custom("LexendDeca-Bold", size: 15))
            .padding(8)
    }
}

struct UserBio_Previews: PreviewProvider {
    static var previews: some View {
        UserBio(name: "Adarsh", text: "wtw babygirl")
    }
}
