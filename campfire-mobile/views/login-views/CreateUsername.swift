//
//  CreateUsername.swift
//  campfire-mobile
//
//  Created by Toni on 6/19/23.
//

import SwiftUI

struct CreateUsername: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text("enter your campfire username")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(placeholderText: "username") 
                        
                        Text("almost there!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 20))
                        
                        LFButton(text: "next"){}
                    }
                    .padding(.bottom, 300)
                    
                    
                }
            )
    }
}


struct CreateUsername_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsername()
    }
}
