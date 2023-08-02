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
    @EnvironmentObject var model: AuthModel
    

    
    // setting up verification code & advancing as view state
    
    var body: some View {
        
        if model.createAccount && model.validVerificationCode {
            EnterEmail()
        }
        else if model.login && model.validVerificationCode {
            NavigationBar()
        }
        else {
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
                        
                        VStack{
                            Text("code sent to \(model.phoneNumber)")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding(-20)
                            Text("(sms data rates may apply)")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding(-5)
                        }
                        
                        // MARK: - NavLink to EnterEmail screen
                        
                        VStack {
                            // if user is creating account, navigate to email set up
        
                                LFButton(text: "verify")

                                // verify user code on tap of link
                                .simultaneousGesture(TapGesture().onEnded{
                                    model.verifyVerificationCode()
                                })
                            // otherwise log them into the main app

                            }
                        .opacity(buttonOpacity)
                        .disabled(!model.validVerificationCodeLength)
                    }
                    .alert(model.errorMessage, isPresented: $model.showError){}
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension VerifyNumber {
    var buttonOpacity: Double {
        return model.validVerificationCodeLength ? 1 : 0.5
    }
}

struct VerifyAccount_Previews: PreviewProvider {
    static var previews: some View {
        VerifyNumber()
            .environmentObject(AuthModel())
    }
}
