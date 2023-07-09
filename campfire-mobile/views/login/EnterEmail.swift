//
//  EnterEmail.swift
//  campfire-mobile
//
//  Created by Toni on 6/18/23.
//

import SwiftUI

struct EnterEmail: View {
    
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) private var dismiss
    
    // setting up user email as view state
    @State var email: String = ""
    @State private var canAdvance: Bool = false
    
    var body: some View {
            GradientBackground()
            .overlay(
                VStack {
// MARK: - Back button
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
                    
// MARK: - Email form & prompts
                    VStack(spacing: 60) {
                        Text("enter your '.edu' email")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: email, placeholderText: "email")
                        
                        Text("check your email for a magic link!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        
                        // MARK: - NavLink to VerifyEmail screen
                        VStack {
                            NavigationLink(destination: VerifyEmail(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .disabled(!canAdvance)
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
