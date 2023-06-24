


import SwiftUI

struct FormTextField: View {
    @State private var text: String = ""
    
    var placeholderText: String
    
    var body: some View {
        VStack {
            TextField(placeholderText, text: $text)
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(Color.white)
                .padding(.horizontal)
            
            Divider()
                .background(Color.black)
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
