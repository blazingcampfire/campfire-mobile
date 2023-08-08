//
//  WelcomeModal.swift
//  campfire-mobile
//
//  Created by Adarsh G on 8/8/23.
//

import SwiftUI

struct WelcomeModal: View {
    var body: some View {
        ZStack {
            Theme.Peach
                .ignoresSafeArea(.all)
            VStack(spacing: 30) {
                Text("welcome to campfire! congratulations on being one of the first users to join our community!")
                    .font(.custom("LexendDeca-Bold", size: 15))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("📸 capture & share: capturing campus moments and experiences and sharing it to the feed")
                    .font(.custom("LexendDeca-Bold", size: 13))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("🫂 connect with friends: check out the tent tab to find your friends and send some requests")
                    .font(.custom("LexendDeca-Bold", size: 13))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("🔥 express your college identity: go to your profile, add some pictures and pick out some prompts")
                    .font(.custom("LexendDeca-Bold", size: 13))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Text("thank you for joining, and welcome to campfire!")
                    .font(.custom("LexendDeca-Bold", size: 15))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct WelcomeModal_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeModal()
    }
}
