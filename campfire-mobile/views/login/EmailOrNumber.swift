//
//  EmailOrNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct EmailOrNumber: View {
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
                GradientBackground()
                .overlay(
                    VStack (spacing: 0) {
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
// MARK: - App logo & title
                        
                        VStack {
                            Image("newlogo")
                                .resizable()
                                .frame(width: 300, height: 300)

                            Text("campfire")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 60))
                                .padding(.top, -30)
                        }
                        .padding(.bottom, 30)

                        // MARK: - NavLinks to EnterPhoneNumber & EmailOrNumber screens

                        VStack {
                            NavigationLink(destination: EnterPhoneNumber(), label: {
                                LFButton(text: "phone number")
                                    .padding(5)
                            })
                            

                            NavigationLink(destination: EnterEmail(), label: {
                                LFButton(text: "email")
                                    .padding(5)
                            })
                        }
                        
                    }
                        .padding(.bottom, 160)
                )
                .navigationBarBackButtonHidden(true)
    
    }
}

struct EmailOrNumber_Previews: PreviewProvider {
    static var previews: some View {
        EmailOrNumber()
    }
}
