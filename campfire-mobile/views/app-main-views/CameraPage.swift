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
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
            
            HStack {
            Button(action: {
                print("yay")
            }) {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 100, height: 90)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 10)
                            .overlay(Image(systemName: "flame").foregroundColor(Theme.Peach).font(.system(size: 30)))
                    )
                    
            }
            .offset(x:15, y:280)
                
                Button {
                    print("upload images")
                } label: {
                    Image(systemName: "square.and.arrow.up.on.square")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .offset(x: 35, y: 280)
        }
        }
        
        
    }
}



struct CameraPage_Previews: PreviewProvider {
    static var previews: some View {
        CameraPage()
    }
}
