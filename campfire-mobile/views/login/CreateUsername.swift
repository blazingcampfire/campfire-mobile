//
//  CreateUsername.swift
//  campfire-mobile
//
//  Created by Toni on 6/19/23.
//

import SwiftUI

struct CreateUsername: View {
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) var dismiss

    // setting up user phoneNumber & advance as view state
    @State var username: String = ""
    @State private var canAdvance: Bool = false
    
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()

                    // MARK: - Username form & prompts

                    VStack(spacing: 60) {
                        Text("enter a campfire username")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                        
                        FormTextField(text: username, placeholderText: "username")
                        
                        Text("almost there!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)
                        
                        // MARK: - NavLink to SetProfilePic screen
                        VStack {
                            NavigationLink(destination: SetProfilePic(), label: {
                                LFButton(text: "next")
                            })
                        }
                        .disabled(!canAdvance)
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

struct CreateUsername_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsername()
    }
}
