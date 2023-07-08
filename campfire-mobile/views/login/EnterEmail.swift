//
//  EnterEmail.swift
//  campfire-mobile
//
//  Created by Toni on 6/18/23.
//

import SwiftUI

struct EnterEmail: View {
    
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255 / 255, green: 50 / 255, blue: 89 / 255, alpha: 1)), Color(.init(red: 255 / 255, green: 153 / 255, blue: 102 / 255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
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
                    
                    VStack(spacing: 60) {
                        Text("enter your '.edu' email")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))

                        FormTextField(placeholderText: "email")

                        Text("check your email for a magic link!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        NavigationLink(destination: VerifyEmail(), label: {
                            LFButton(text: "next")
                        })

                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
        }
}

struct EnterEmail_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmail()
    }
}
