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
                    Spacer()
// MARK: - Email form & prompts
                    VStack(spacing: 60) {
                        Text("enter your first name")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: $model.name, placeholderText: "name", characterLimit: 20, unallowedCharacters: nameIllegalChar)
                        
                        
                        // MARK: - NavLink to VerifyEmail screen
                        VStack {
                            NavigationLink(destination: SetProfilePic(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .opacity(buttonOpacity)
                        .disabled(!model.validName)
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
