//
//  EnterPhoneNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct EnterPhoneNumber: View {
    
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) var dismiss
    
    // setting up user phoneNumber as view state
    @State var phoneNumber: String = ""
    
    var body: some View {
                GradientBackground()
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

                        // - MARK: Form & text prompts
                        VStack(spacing: 60) {
                            Text("enter your phone number")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 25))

                            FormTextField(text: phoneNumber, placeholderText: "phone number")

                            Text("check your messages for a verification code!")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 15))
                                .padding(-20)

                            // - MARK: NavLink to VerifyNumber screen
                            NavigationLink(destination: VerifyNumber(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .padding(.bottom, 200)
                    }
                )
                .navigationBarBackButtonHidden(true)
        }
}

struct EnterPhoneNumber_Previews: PreviewProvider {
    static var previews: some View {
        EnterPhoneNumber()
    }
}
