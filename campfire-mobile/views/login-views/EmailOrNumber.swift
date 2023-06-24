//
//  EmailOrNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//

import SwiftUI

struct EmailOrNumber: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    VStack {
                        Image("newlogo")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .offset(x: 0, y: 20)
                        
                        Text("campfire")
                            .foregroundColor(Color.white)
                            .font(.custom("LexendDeca-Bold", size: 60))
                        
                        
                    }
                    LFButton(text: "phone number"){}
                        .padding(10)
                    
                    LFButton(text: "email"){}
                        .padding(10)
                    
                })
    }
}

struct EmailOrNumber_Previews: PreviewProvider {
    static var previews: some View {
        EmailOrNumber()
    }
}
