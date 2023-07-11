//
//  VerifyAccount.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct VerifyNumber: View {
    // setting up view dismiss == going back to previous screen, initializing authModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: authModel
    
    // setting up verification code & advancing as view state
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()

                    // MARK: - Verification code form & prompts

                    VStack(spacing: 60) {
                        Text("enter verification code")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.verificationCode, placeholderText: "verification code")
                            .keyboardType(.numberPad)                        
                        Text("code sent to \(model.phoneNumber)")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        
                        // MARK: - NavLink to EnterEmail screen
                        
                        VStack {
                            NavigationLink(destination: EnterEmail(), label: {
                                LFButton(text: "verify")
                            }
                            )
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validVerificationCode)
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

extension VerifyNumber {
    var buttonOpacity: Double {
        return model.validVerificationCode ? 1 : 0.5
    }
}

struct VerifyAccount_Previews: PreviewProvider {
    static var previews: some View {
        VerifyNumber()
            .environmentObject(authModel())
    }
}
