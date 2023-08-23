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
    @EnvironmentObject var notificationsManager: NotificationsManager

    var body: some View {
        if model.login && model.validVerificationCode {
            NavigationBar()
                .environmentObject(currentUser)
                .environmentObject(notificationsManager)
                .onAppear {
                    currentUser.setCollectionRefs()
                    currentUser.getProfile()
                    currentUser.getUser()
                }
        } else {
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

                            VStack {
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
                                if model.createAccount && model.validVerificationCode {
                                    NavigationLink(destination: EnterEmail(), label: {
                                        LFButton(text: "next")
                                    })
                                } else {
                                    Button {
                                        Task {
                                            do {
                                                await model.verifyVerificationCode()
                                            }
                                        }
                                    } label: {
                                        LFButton(text: "verify")
                                    }
                                    .opacity(buttonOpacity)
                                    .disabled(!model.validVerificationCodeLength)
                                }
                            }
                        }
                        Spacer()
                    }
                    .alert(title: "Error Verifying Number", message: model.errorMessage,
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
}

extension VerifyNumber {
    var buttonOpacity: Double {
        return model.validVerificationCodeLength ? 1 : 0.5
    }
}
