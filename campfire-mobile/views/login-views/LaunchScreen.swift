//
//  LaunchScreen.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI


struct LaunchView: View {
    var body: some View {
        
        // Color(.init(red: 0, green: 0, blue: 0, alpha: 1))
        
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
                    .overlay(
        ZStack {
            VStack {
                Image("newlogo")
                    .resizable()
                    .frame(width: 190, height: 190)
                
                Text("campfire")
                    .foregroundColor(Color.white)
                    .font(.custom("LexendDeca-Bold", size: 60))
                
                
            }
            
        })
    }
    
}



struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
