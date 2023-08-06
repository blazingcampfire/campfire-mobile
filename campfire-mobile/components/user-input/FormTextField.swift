

import SwiftUI

struct FormTextField: View {
    @Binding var text: String

    var placeholderText: String
    @FocusState var isEnabled: Bool

    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(Color.white)
                .padding(.horizontal)
                .focused($isEnabled)
                .autocapitalization(.none)

            ZStack {
                Rectangle()
                    .fill(.white.opacity(0.5))
                
                Rectangle()
                    .fill(.white)
                    .frame(width: isEnabled ? nil : 0)
                    .animation(.easeInOut( duration: 0.3), value: isEnabled)
                    
            }
            .frame(height: 3)
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormTextField(text: .constant("now what's the word captain"), placeholderText: "yo")
    }
}
