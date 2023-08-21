//
//  LaunchScreen.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI


struct LaunchScreen: View {
    
    @State var splashShow: Bool = false
    
    
    
    var body: some View {
    
        if splashShow {
            AccountSetUp()
        } else {
            GradientBackground()
            .overlay(
                VStack {
        // MARK: - App logo
                    VStack {
                        Image("newlogo")
                            .resizable()
                            .frame(width: 300, height: 300, alignment: .center)
                            .offset(x:-8, y: -70)
                    }
                })
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    splashShow = true
                }
            }
        }
        
        
        
  
    }
    
}
