//
//  EnterPhoneNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI
import iPhoneNumberField

struct EnterPhoneNumber: View {
    // setting up view dismiss == going back to previous screen, initializing authModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: AuthModel
    @State var canAdvance: Bool = false
    
    var body: some View {
        if model.login && canAdvance {
            VerifyNumber()
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
                                BackButton(color: .white)
                            }
                        }
                        .padding(.leading, 15)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        Spacer()
                        
                        // MARK: - Form & text prompts
                        
                        VStack(spacing: 60) {
                            Text("enter your phone number")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 25))
                            
//                            FormTextField(text: $model.phoneNumber, placeholderText: "phone number" )
//                                .keyboardType(.numberPad)
                            PhoneNumberField(text: $model.phoneNumber)
                                .keyboardType(.numberPad)
                                .background(Color.clear)
                                
                            if !model.validPhoneNumber {
                                Text("phone number must be 10 digits with no spaces")
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
                                
                                NavigationLink(destination: VerifyNumber(), label: {
                                    LFButton(text: "next")
                                })
                                // on tap, navLink gets user verification code
                                .simultaneousGesture(TapGesture().onEnded{
                                    model.getVerificationCode()
                                    print(model.phoneNumber)
                                    canAdvance = true
                                })
                            }
                            .opacity(buttonOpacity)
                            .disabled(!model.validPhoneNumber)
                        }
                    }
                    .padding(.bottom, 200)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    )
                    .navigationBarBackButtonHidden(true)
                }

    }
}

extension EnterPhoneNumber {
    var buttonOpacity: Double {
        return model.validPhoneNumber ? 1 : 0.5
    }
}

struct EnterPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumber()
    }
}
