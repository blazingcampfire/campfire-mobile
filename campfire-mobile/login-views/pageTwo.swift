//
//  pageTwo.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/17/23.
//

import SwiftUI
struct SwiftUIView: View {
    var body: some View {
        ZStack {
            Image("logoColor").resizable().frame(width: 170, height: 170).offset(x: -110, y: -250)
            Text("CampFire").frame(width: 200, height: 200, alignment: .top).font(.system(size: 25)).offset(x: 15, y: -155)
            
            Text("share your favorite moments around your campus CampFire!").font(.system(size: 15)).offset(x: 0, y: -180).multilineTextAlignment(.center)
            
            Button(action: {
                print("wiwiw")
            }) {
                Text("create account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .background(Color.orange) // If you have this
            .cornerRadius(25)
            .offset(x: 2, y: 150)
            
            Button(action: {
                print("wiwiw")
            }) {
                Text("sign in")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            .background(Color.red) // If you have this
            .cornerRadius(25)
            .offset(x: 2, y: 200)
        }
    }
    
    
    
    
    struct SwiftUIView_Previews: PreviewProvider {
        static var previews: some View {
            SwiftUIView()
        }
    }
}
