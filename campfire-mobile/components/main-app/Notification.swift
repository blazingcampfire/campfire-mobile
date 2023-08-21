//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/30/23.
//

import SwiftUI

struct Notification: View {
    var title: String = "Friend Request"
    var content: String = "Adarsh Gadepalli has sent you a friend request!"
    var timeStamp: String = "11:37am"

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(title)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                    .font(.custom("LexendDeca-Bold", size: 20))
                Spacer()
                Text(timeStamp)
                    .padding(.trailing, 10)
                    .padding(.top, 5)
                    .font(.custom("LexendDeca-Regular", size: 15))
            }
            .foregroundColor(.white)
            HStack {
                Text(content)
                    .padding(.leading, 10)
                    .padding(.top, 5)
                    .font(
                        .custom("LexendDeca-Regular", size: 15))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.bottom, 10)
        }
        .background(Theme.Peach)
        .cornerRadius(8)
        .padding()
    }
}
