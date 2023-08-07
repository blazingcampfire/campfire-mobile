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
    @EnvironmentObject var currentUser: CurrentUserModel
    @State var validPhoneNumber: Bool = false
    

    
    // setting up verification code & advancing as view state
    
    var body: some View {
        
        if model.createAccount && model.validVerificationCode {
            EnterEmail()
        }
        else if model.login && validPhoneNumber {
            NavigationBar()
                .environmentObject(currentUser)
        }
        else {
        GradientBackground()
            .overlay(
                VStack {
                    Spacer()
                    // MARK: - Verification code form & prompts
                    VStack(spacing: 60) {
                        Text("enter verification code")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.verificationCode, placeholderText: "verification code")
                            .keyboardType(.numberPad)
                        
                        VStack{
                            Text("code sent to \(model.formattedPhoneNumber)")
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
                                    if model.login {
                                        currentUser.setCollectionRefs()
                                        currentUser.getProfile()
                                        currentUser.getUser()
                                        validPhoneNumber = true
                                    }
                                })
                            // otherwise log them into the main app

                            }
                        .opacity(buttonOpacity)
                        .disabled(!model.validVerificationCodeLength)
                    }
                    Spacer()
                }
                    .alert(model.errorMessage, isPresented: $model.showError){}
                .ignoresSafeArea(.keyboard, edges: .bottom)
            )
            .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: Theme.ButtonColor))
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
    }
}
