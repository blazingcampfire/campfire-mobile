//
//  VerifyAccount.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct VerifyAccount: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    
                    Spacer()
                    
                    VStack(spacing: 60) {
                        Text("enter verification code")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                       FormTextField(placeholderText: "verification code")
                        
                        Text("code sent to (number)")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
               
                        
                        LFButton(text: "verify"){}
                    }
                    .padding(.bottom, 200)

                    
                }
            )
    }
}

struct VerifyAccount_Previews: PreviewProvider {
    static var previews: some View {
        VerifyAccount()
    }
}
