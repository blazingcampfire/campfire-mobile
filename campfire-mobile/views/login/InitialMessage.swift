//
//  InitialMessage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/9/23.
//

import SwiftUI

struct InitialMessage: View {
    let school: String
    var body: some View {
        ZStack {
            Theme.Peach
                .ignoresSafeArea(.all)
            VStack(spacing: 25) {
                VStack {
                    Text("welcome to campfire!")
                        .font(.custom("LexendDeca-Bold", size: 20))
                    Text("before you begin...")
                        .font(.custom("LexendDeca-Regular", size: 20))
                }
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                
                
                VStack(alignment: .leading, spacing: 5){
                    Text("- campfire is not associated with \(school)")
                    Text("- check out funny pictures and videos on the feed")
                    Text("- see what's going on around campus on the map")
                    Text("- add your own favorite pics and vids with the camera")
                    Text("- use the tent to stay up to date with the latest news and find new friends")
                    Text("- customize your profile with your favorite flicks from around campus")
                    Text("- most importantly, enjoy your time around the campfire!")
                }
                .foregroundColor(Color.white)
                .font(.custom("LexendDeca-SemiBold", size: 16))
                .multilineTextAlignment(.center)
                .padding(.leading, 7)
                .frame(width: 350, alignment: .center)
            }
        }
    }
}

struct InitialMessage_Previews: PreviewProvider {
    static var previews: some View {
        InitialMessage(school: "Yale")
    }
}
