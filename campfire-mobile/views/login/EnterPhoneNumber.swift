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
    
    var body: some View {
        if model.validPhoneNumber {
            VerifyNumber()
        }
        else {
        GradientBackground()
            .overlay(
                    VStack {
                        Spacer()
                        // MARK: - Form & text prompts
                        VStack(spacing: 60) {
                            Text("enter your phone number")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 25))
                            
//                            FormTextField(text: $model.phoneNumber, placeholderText: "phone number" )
//                                .keyboardType(.numberPad)
                            PhoneNumberField(text: $model.formattedPhoneNumber, placeholderText: "phone number")
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
                                Button {
                                    model.getVerificationCode()
                                    print(model.phoneNumber)
                                } label: {
                                    LFButton(text: "next")
                                }
                            
                            }
                            .opacity(buttonOpacity)
                            .disabled(!model.validPhoneNumberString)
                        }
                        Spacer()
                    }
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

extension EnterPhoneNumber {
    var buttonOpacity: Double {
        return model.validPhoneNumberString ? 1 : 0.5
    }
}

struct EnterPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumber()
    }
}
