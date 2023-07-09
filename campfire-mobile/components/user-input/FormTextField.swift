

import SwiftUI

struct FormTextField: View {
    @Binding var text: String

    var placeholderText: String
    var textContentType: String?
    var keyboardType: String?

    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(Color.black)
                .padding(.horizontal)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)

            Divider()
                .background(Color.white)
                .frame(height: 3)
                .overlay(.white)
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormTextField(text: .constant("now what's the word captain"), placeholderText: "yo")
    }
}
