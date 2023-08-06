//
//  CreateUsername.swift
//  campfire-mobile
//
//  Created by Toni on 6/19/23.
//

import SwiftUI

struct CreateUsername: View {
    // setting up environmental variables
    @Environment(\.dismiss) var dismiss
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()

                    // MARK: - Username form & prompts

                    VStack(spacing: 60) {
                        Text("enter a campfire username")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.username, placeholderText: "username")
                        
                        Text("almost there!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        
                        // MARK: - NavLink to SetProfilePic screen
                        VStack {
                            NavigationLink(destination: EnterName(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validUsername)
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

extension CreateUsername {
    var buttonOpacity: Double {
        return model.validUsername ? 1 : 0.5
    }
}

struct CreateUsername_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsername()
    }
}
