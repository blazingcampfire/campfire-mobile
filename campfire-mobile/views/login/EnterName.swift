//
//  EnterName.swift
//  campfire-mobile
//
//  Created by Toni on 7/21/23.
//

import SwiftUI

struct EnterName: View {
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
                            BackButton(color: .white)
                        }
                    }
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .topLeading)
                    Spacer()
                    
// MARK: - Email form & prompts
                    VStack(spacing: 60) {
                        Text("enter your first name")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.name, placeholderText: "name")
                        
                        
                        // MARK: - NavLink to VerifyEmail screen
                        VStack {
                            NavigationLink(destination: SetProfilePic(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validName)
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
        }
}

extension EnterName {
    var buttonOpacity: Double {
        return model.validName ? 1 : 0.5
    }
}

struct EnterName_Previews: PreviewProvider {
    static var previews: some View {
        EnterName()
    }
}
