

import SwiftUI

struct FormTextField: View {
    @Binding var text: String
    var placeholderText: String
    @FocusState var isEnabled: Bool

    var characterLimit: Int?
    var unallowedCharacters: [String]?

    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(Color.white)
                .padding(.horizontal)
                .focused($isEnabled)
                .autocapitalization(.none)
                .onChange(of: text) { newValue in
                    if let limit = characterLimit, newValue.count > limit {
                        text = String(newValue.prefix(limit))
                    }

                    if let unallowedChars = unallowedCharacters {
                        unallowedChars.forEach { char in
                            text = text.replacingOccurrences(of: char, with: "")
                        }
                    }
                }

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
        .frame(height: 80)
        .padding(.horizontal)
    }
}
