//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

// model for our reusable components
struct LFButton: View {
    var text: String
    var clicked: (() -> Void)
    var icon: Image?
    
    var body: some View {
        Button(action: clicked) {
                HStack {
                    Text(text).font(.custom("Futura-Bold", size: 25))
                        .padding(.trailing, 5)
                    
                    icon
                    
                }.frame(width: 300, alignment: .center)
                .foregroundColor(Color.white)
                .padding()
                .background(Theme.Peach)
                .cornerRadius(16)
        }
        }
    }

struct LFButton_Previews: PreviewProvider {
    static var previews: some View {
        LFButton(
            text: "create account", clicked:  {
                print("Clicked")
            })
    }
}
