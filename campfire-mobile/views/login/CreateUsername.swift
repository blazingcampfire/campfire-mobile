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
                    Spacer()
                    // MARK: - Username form & prompts
                    VStack(spacing: 60) {
                        Text("enter a campfire username")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.username, placeholderText: "username", characterLimit: 20, unallowedCharacters: usernameIllegalChar)
                        
                        if !model.validUsername {
                            Text("username must be 4-17 characters w/ no special characters")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 13))
                                .padding(.top, -40)
                        }
                       
                        
                        // MARK: - NavLink to SetProfilePic screen
                        VStack {
                            NavigationLink(destination: SetProfilePic(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validUsername)
                    }
                    Spacer()
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            )
            .onTapGesture {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(dismiss: self.dismiss, color: .white))
    }
}

extension CreateUsername {
    var buttonOpacity: Double {
        return model.validUsername ? 1 : 0.5
    }
}
