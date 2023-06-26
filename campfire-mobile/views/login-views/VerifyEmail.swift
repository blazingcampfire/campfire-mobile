//
//  VerifyEmail.swift
//  campfire-mobile
//
//  Created by Toni on 6/18/23.
//

import SwiftUI

struct VerifyEmail: View {
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack {
                    VStack {
                        VStack{
                            Image(systemName: "graduationcap.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                                .padding(10)
                                
                            
<<<<<<< HEAD
                            Text("choose an option below to verify your email:") .font(.custom("LexendDeca-Bold", size: 20))
                                .frame(width: 380, alignment: .leading)
                                .foregroundColor(Color.white).padding(5).offset(x: 20, y: -80).multilineTextAlignment(.center)
=======
                            Text("choose an option below to verify your email:") .font(.custom("LexendDeca-Bold", size: 25))
                                .frame(width: 380, alignment: .center)
                                .foregroundColor(Color.white).padding(15).multilineTextAlignment(.center)
>>>>>>> b07eebeb0036d37c2f996bd9cb24926e82fd90e1
                            
                            Text("memellord@hustleruniversity.edu")
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .frame(width: 380, height: 10, alignment: .center)
                                .foregroundColor(.white)
<<<<<<< HEAD
                                .accentColor(.white).offset(x:20, y: -80).multilineTextAlignment(.center)
=======
                                .accentColor(.white).multilineTextAlignment(.center)
                                .padding(15)
>>>>>>> b07eebeb0036d37c2f996bd9cb24926e82fd90e1

                                
                        }
                        .padding(40)
                    }
                    
                    LFButton(text: "Microsoft", clicked: {}, icon: Image("microsoftlogo"))
                        .padding(5)
                    
                    LFButton(text: "Google", clicked: {}, icon: Image("glogo2"))
                       
                    
                })
    }
}


struct VerifyEmail_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmail()
    }
}
