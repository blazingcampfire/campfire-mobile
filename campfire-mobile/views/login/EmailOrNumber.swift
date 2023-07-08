//
//  EmailOrNumber.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/18/23.
//  LIKELY WON'T NEED THIS FILE AS OUR USERS WILL NEED TO SIGN UP USING BOTH EMAIL & PHONE #
//

import SwiftUI

struct EmailOrNumber: View {
    var body: some View {
            LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255 / 255, green: 50 / 255, blue: 89 / 255, alpha: 1)), Color(.init(red: 255 / 255, green: 153 / 255, blue: 102 / 255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                    VStack {
                        HStack {
                            Image(systemName: "arrowshape.backward.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 25))
                            Text("back")
                                .font(.custom("LexendDeca-Bold", size: 20))
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity,  maxHeight: .infinity, alignment: .topLeading)
                       
                        VStack {
                            Image("newlogo")
                                .resizable()
                                .frame(width: 300, height: 300)
                            
                            Text("campfire")
                                .foregroundColor(Color.white)
                                .font(.custom("LexendDeca-Bold", size: 60))
                                .padding(.top, -30)
                        }
                        .padding(.bottom, 30)
                        
                        
                        NavigationLink(destination: EnterPhoneNumber(), label: {
                            LFButton(text: "phone number")})
                        .padding(5)
                        

                        
                        NavigationLink(destination: EnterEmail(), label: {
                            LFButton(text: "email")})
                        .padding(5)
                        
                    }
                )
                .navigationBarBackButtonHidden(true)
    
    }
}

struct EmailOrNumber_Previews: PreviewProvider {
    static var previews: some View {
        EmailOrNumber()
    }
}
