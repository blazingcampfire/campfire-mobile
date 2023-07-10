//
//  CommentTextField.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 7/9/23.
//

import SwiftUI



struct CommentTextField: View {
    @State private var text: String = ""
    var placeholderText: String

    var body: some View {
        VStack {
            
            HStack(spacing: 0){
            Image(info.profilepic)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            VStack{
                TextField(placeholderText, text: $text)
                    .font(.custom("LexendDeca-Light", size: 18))
                    .foregroundColor(Color.black)
                    .padding(.horizontal)
                Divider()
                    .background(Color.black)
                    .frame(width: 285, height: 3)
                    .overlay(.black)
            }
            
        }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}

struct CommentTextField_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextField(placeholderText: "add comment...")
    }
}
