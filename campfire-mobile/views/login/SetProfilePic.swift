//
//  SetProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI
import PhotosUI

struct SetProfilePic: View {
    // setting up view dismiss == going back to previous screen
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    Spacer()

                    // MARK: - Profile picture upload button & prompts

                    VStack(spacing: 60) {
                        Text("upload a profile picture")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .padding(.top, 100)

                        ProfilePictureView()

                        Text("you're ready!")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 15))
                            .padding(-20)

                        // MARK: - Button redirecting to main app

                        VStack {
                            // set destination to AccountSetUp screen temporarily
                                LFButton(text: "finish")
                        }
                        .opacity(buttonOpacity)
                        .onTapGesture {
                            model.createUser()
                        }
                    }
                    .padding(.bottom, 200)
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

extension SetProfilePic {
    var buttonOpacity: Double {
        return model.validProfilePic ? 1 : 0.5
    }
}

struct SetProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        SetProfilePic()
            .environmentObject(AuthModel())
    }
}
