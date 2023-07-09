//
//  LaunchScreen.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI


struct LaunchView: View {
    var body: some View {
        
        
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
                    .overlay(
        VStack {
            // - MARK: App logo
            VStack {
                Image("newlogo")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    .offset(x:-8, y: -70)
                
                
            }
            
        })
    }
    
}



struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
