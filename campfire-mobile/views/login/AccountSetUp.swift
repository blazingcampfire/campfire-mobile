//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct AccountSetUp: View {
    
    var body: some View {
        NavigationStack {
            LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                    VStack {
                        // - MARK: App logo & title
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
                        
                        // - MARK: NavLinks to EnterPhoneNumber & EmailOrNumber screens
                        VStack {
                            NavigationLink(destination: EnterPhoneNumber(), label: {
                                LFButton(text: "create account")}
                            )
                            
                            NavigationLink(destination: EmailOrNumber(), label: {
                                LFButton(text: "login")
                            })
                        }
                    }
                    .padding(.bottom, 100)
                )
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetUp()
    }
}

