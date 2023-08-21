//
//  EnterPhoneNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import iPhoneNumberField
import SwiftUI

struct EnterPhoneNumber: View {
    // setting up view dismiss == going back to previous screen, initializing authModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: AuthModel

    var body: some View {
        GradientBackground()
            .overlay(
                VStack {
                    Spacer()

                    // MARK: - Form & text prompts

                    VStack(spacing: 60) {
                        Text("enter your phone number")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))

                        PhoneNumberField(text: $model.formattedPhoneNumber, placeholderText: "phone number")
                            .keyboardType(.numberPad)
                            .background(Color.clear)

                        if !model.validPhoneNumberString {
                            Text("phone number must be 10 digits")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 13))
                                .padding(.top, -40)
                        }

                        Text("check your messages for a verification code!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)

                        // MARK: - NavLink to VerifyNumber screen

                        VStack {
                            if model.validPhoneNumber {
                                NavigationLink(destination: VerifyNumber(), label: {
                                    LFButton(text: "next")
                                })
                            } else {
                                Button {
                                    Task {
                                        model.getVerificationCode()
                                    }
                                } label: {
                                    LFButton(text: "send code")
                                }
                                .opacity(buttonOpacity)
                                .disabled(!model.validPhoneNumberString)
                            }
                        }
                    }
                    Spacer()
                }
                    .alert(title: "Invalid Phone Number", message: model.errorMessage,
                                   dismissButton: CustomAlertButton(title: "ok", action: { }),
                               isPresented: $model.showError)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            )
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: .white))
    }
}

extension EnterPhoneNumber {
    var buttonOpacity: Double {
        return model.validPhoneNumberString ? 1 : 0.5
    }
}
