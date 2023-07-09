//
//  VerifyAccount.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct VerifyNumber: View {
    
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255 / 255, green: 50 / 255, blue: 89 / 255, alpha: 1)), Color(.init(red: 255 / 255, green: 153 / 255, blue: 102 / 255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    // - MARK: Back button
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                    }
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .topLeading)
                    Spacer()

                    // - MARK: Verification code form & prompts
                    VStack(spacing: 60) {
                        Text("enter verification code")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))

                        FormTextField(placeholderText: "verification code")

                        Text("code sent to (number)")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        
                        // - MARK: NavLink to EnterEmail screen
                        NavigationLink(destination: EnterEmail(), label: {
                            LFButton(text: "verify")
                        }
                        )
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

struct VerifyAccount_Previews: PreviewProvider {
    static var previews: some View {
        VerifyNumber()
    }
}
