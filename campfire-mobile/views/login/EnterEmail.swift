//
//  EnterEmail.swift
//  campfire-mobile
//
//  Created by Toni on 6/18/23.
//

import SwiftUI

struct EnterEmail: View {
    
    // setting up environmental variables
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: AuthModel
    
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
                        
                        FormTextField(text: $model.email, placeholderText: "email")
                        
                        if !model.validEmail {
                            Text("at this time, campfire is only at Yale, Rice, and Notre Dame")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 13))
                                .multilineTextAlignment(.center)
                                .padding(.top, -40)
                        }
                        
                        // MARK: - NavLink to VerifyEmail screen
                        VStack {
                            NavigationLink(destination: VerifyEmail(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validEmailString)
                    }
                    .padding(.bottom, 200)
                }
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .navigationBarBackButtonHidden(true)
        }
}

extension EnterEmail {
    var buttonOpacity: Double {
        return model.validEmailString ? 1 : 0.5
    }
}

struct EnterEmail_Previews: PreviewProvider {
    static var previews: some View {
        EnterEmail()
            .environmentObject(AuthModel())
    }
}
