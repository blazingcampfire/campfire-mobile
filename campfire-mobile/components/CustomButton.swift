//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct LaunchButton: View {
    var text: String
    var clicked: (() -> Void)
    
    var body: some View {
        Button(action: clicked) {
                HStack {
                    Text(text).font(.custom("Futura-Bold", size: 25))
                    
                }.frame(width: 300, alignment: .center)
                .foregroundColor(Color.white)
                .padding()
                .background(HotPeach.Peach)
                .cornerRadius(16)
        }
        }
    }

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        LaunchButton(
            text: "create account") {
                print("Clicked")
            }
    }
}
