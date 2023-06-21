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
            Image("")
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
                            .stroke(Color.black, lineWidth: 10)
                    )
            }
            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 150)
            
            Image(systemName: "square.and.arrow.up").resizable()
                .frame(width: 20, height: 40)
                .offset(x: 100, y: 320)
        }
        
        
    }
}


struct CameraPage_Previews: PreviewProvider {
    static var previews: some View {
        CameraPage()
    }
}
