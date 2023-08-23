//
//  PhoneNumberField.swift
//  campfire-mobile
//
//  Created by Toni on 8/6/23.
//

import iPhoneNumberField
import SwiftUI

struct PhoneNumberField: View {
    @Binding var text: String

    @FocusState var isEnabled: Bool
    var placeholderText: String

    var body: some View {
        VStack {
            iPhoneNumberField(placeholderText, text: $text)
                .font(UIFont(name: "LexendDeca-Bold", size: 20))
                .accentColor(Color.white)
                .foregroundColor(Color.white)
                .padding(.horizontal)
                .focused($isEnabled)

            ZStack {
                Rectangle()
                    .fill(.white.opacity(0.5))

                Rectangle()
                    .fill(.white)
                    .frame(width: isEnabled ? nil : 0)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
            }
            .frame(height: 3)
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
