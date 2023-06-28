//
//  CameraPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/20/23.
//

import SwiftUI

struct CameraPage: View {
    @State private var flashTapped: Bool = false
    
    var body: some View {
        
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
            
            
            VStack(spacing:10) {
                Button(action: {
                    print("flip camera")
                    self.flashTapped.toggle()
                }) {
                    Image(systemName: self.flashTapped == true ? "bolt.circle" : "bolt.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size:40))
                }
                
                
                Button(action: {
                    print("flip camera")
                }) {
                    Image(systemName: "arrow.2.squarepath")
                        .foregroundColor(.white)
                        .font(.system(size:35, weight: .semibold))
                }
            }
            .padding(.top,-300)
            .padding(.leading, 290)
            
            
            
            
            
            
            VStack {
                Spacer()
                
              
                
                
                HStack(spacing: 25) {
          
                    
                    Button(action: {
                        print("yay")
                    }) {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 100, height: 90)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 10)
                                    .overlay(
                                        Image(systemName: "flame")
                                            .foregroundColor(Theme.Peach)
                                            .font(.system(size: 30))
                                    )
                            )
                    }
                    .padding(.bottom, 10)
                    
            
                    Button(action: {
                        print("upload images")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 55)
            }
            .padding(.bottom, 25)
        }
    }
}




struct CameraPage_Previews: PreviewProvider {
    static var previews: some View {
        CameraPage()
    }
}
