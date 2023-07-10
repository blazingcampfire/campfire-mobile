//
//  InitialMessage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/9/23.
//

import SwiftUI

struct InitialMessage: View {
    var body: some View {
        VStack(spacing: 25) {
            VStack {
                Text("welcome to campfire!")
                    .font(.custom("LexendDeca-Bold", size: 20))
                Text("before you begin...")
                    .font(.custom("LexendDeca-Regular", size: 20))
            }
            .foregroundColor(Theme.TextColor)
       
            
            VStack(spacing: 5){
                Text("- campfire is not associated with Yale")
                Text("- check out funny pictures and videos on the feed")
                Text("- see what's going on around campus on the map")
                Text("- add your own favorite pics and vids with the camera")
                Text("- use the tent to stay up to date with the latest news and find new friends")
                Text("- customize your profile with your favorite flicks from around campus")
                Text("- most importantly, enjoy the time around your campus campfire!")
            }
            .foregroundColor(Theme.TextColor)
            .font(.custom("LexendDeca-Light", size: 16))
            .multilineTextAlignment(.leading)
        }
        
    }
}

struct InitialMessage_Previews: PreviewProvider {
    static var previews: some View {
        InitialMessage()
    }
}
