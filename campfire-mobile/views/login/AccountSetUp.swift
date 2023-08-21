//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct AccountSetUp: View {
    @EnvironmentObject var model: AuthModel
    var body: some View {
        NavigationView {
            GradientBackground()
                .overlay(
                    VStack (spacing: 0) {
                        // MARK: - App logo & title
                        VStack {
                            Image("s'more")
                                .resizable()
                                .frame(width: 200, height: 200)

                            Text("campfire")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 60))
                                .padding(.top, -25)
                        }
                        .padding(.bottom, 30)

                        // MARK: - NavLinks to EnterPhoneNumber & EmailOrNumber screens

                        VStack {
                            NavigationLink(destination: EnterPhoneNumber(), label: {
                                LFButton(text: "create account")
                                    .padding(5)
                            })
                            .simultaneousGesture(TapGesture().onEnded({
                                model.createAccount = true
                                model.login = false
                            }))

                            NavigationLink(destination: EmailOrNumber(), label: {
                                LFButton(text: "login")
                                    .padding(5)
                            })
                            .simultaneousGesture(TapGesture().onEnded({
                                model.login = true
                                model.createAccount = false
                            }))
                        }
                    }
                    .padding(.bottom, 100)
                )
        }
        .onAppear {
            model.triggerRestart()
        }
    }
}
