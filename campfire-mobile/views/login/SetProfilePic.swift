//
//  SetProfilePic.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/19/23.
//

import SwiftUI

struct SetProfilePic: View {
    
    // setting up view dismiss == going back to previous screen
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
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
                    
                    // - MARK: Profile picture upload button & prompts
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
                        
                        // - MARK: Button redirecting to main app
                        LFButton(text: "finish")
                        /*
                        NavigationLink(destination: NavigationBar(selectedTabIndex: 0), label: {
                            LFButton(text: "finish")
                        })
                        */

                    }
                    .padding(.bottom, 200)
                    
                }
            )
            .navigationBarBackButtonHidden(true)
    }
}

struct SetProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        SetProfilePic()
    }
}
