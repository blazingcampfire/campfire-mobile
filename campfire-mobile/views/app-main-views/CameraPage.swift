//
//  CameraPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/20/23.
//

import SwiftUI

struct CameraPage: View {
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            Button(action: {
                print("yay")
            }) {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 100, height: 90)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 10)
                    )
            }
            .offset(x:0, y:280)
            
        }
        
        
    }
}


struct CameraPage_Previews: PreviewProvider {
    static var previews: some View {
        CameraPage()
    }
}
