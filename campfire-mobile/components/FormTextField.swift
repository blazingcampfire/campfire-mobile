import SwiftUI

struct FormTextField: View {
    @State private var text: String = ""
    
    var placeholderText: String
    
    var body: some View {
        Form {
            TextField(placeholderText, text: $text)
                .font(.custom("Futura-Bold", size: 20))
                .frame(width: 300, height: 10, alignment: .center)
                .foregroundColor(Color.white)
                .padding()
                .background(HotPeach.Peach)
                .cornerRadius(16)
        }
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormTextField(placeholderText: "yo")
    }
}
