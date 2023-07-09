

import SwiftUI

struct FormTextField: View {
    @State var text: String = ""

    var placeholderText: String

    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(Color.black)
                .padding(.horizontal)

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
        FormTextField(placeholderText: "yo")
    }
}
