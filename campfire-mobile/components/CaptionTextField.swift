//
//  CaptionTextField.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/29/23.
//

import SwiftUI

struct CaptionTextField: View {
   @Binding var text: String

    var placeholderText: String

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Text("caption")
                    .font(.custom("LexendDeca-Bold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .offset(x: 0, y: -25)

                TextField(placeholderText, text: $text)
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .foregroundColor(Color.white)
                    .padding(.horizontal)
                    .frame(width: 360, height: 35)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
