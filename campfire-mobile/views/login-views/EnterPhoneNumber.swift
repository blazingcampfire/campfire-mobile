//
//  EnterPhoneNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct EnterPhoneNumber: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text("enter your phone number")
                            .foregroundColor(Color.white)
                            .font(.custom("Futura-Bold", size: 25))
                        
                        CustomTextBox(placeholderText: "phone number")
                        
                        Text("check your texts for a verification code!")
                            .foregroundColor(Color.white)
                            .font(.custom("Futura-Bold", size: 13))
                    }
                    .padding(.bottom, 100)
                    
                    Spacer()
                    
                    LaunchButton(text: "next"){}
                }
            )
    }
}


struct EnterPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumber()
    }
}
