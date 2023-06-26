//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct AccountSetUp: View {
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    VStack {
                        Image("newlogo")
                            .resizable()
                            .frame(width: 300, height: 300)
                            .offset(x:0, y: 20)
                        
                        Text("campfire")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 60))

                        
                    }
                    LFButton(text: "create account"){}
                        .padding(10)
                    LFButton(text: "login"){}
                        .padding(10)
                    
                })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetUp()
    }
}

