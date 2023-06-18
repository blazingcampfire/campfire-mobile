//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct CreateAccount: View {
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    VStack {
                        Image(systemName: "fireplace")
                                        .font(.system(size: 100))
                                        .foregroundColor(.white).padding(1)
                        
                        Text("campfire")
                            .foregroundColor(Color.white)
                            .font(.custom("Futura-Bold", size: 60))
                        
                        
                    }
                    LaunchButton(text: "create account"){}.padding(8)
                    LaunchButton(text: "login"){}.padding(8)
                    
                })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
