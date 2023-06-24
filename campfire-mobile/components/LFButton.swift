//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

// model for our reusable components
struct LFButton: View {
    var text: String
    var clicked: (() -> Void)
    var icon: Image?
    
    var body: some View {
            Button(action: clicked) {
                HStack {
                    if let icon = icon {
                        if icon == Image("glogo2") {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 30)
                                .offset(x: -40, y: 0)
                        } else if icon == Image("microsoftlogo") {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 30)
                                .offset(x: -30, y: 0)
                        } else {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 30)
                                .offset(x: -30, y: 0)
                        }
                            
                    }
                    
                    if text == "Microsoft"{
                        Text(text)
                            .font(.custom("Comfortaa-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: -11, y: 0)
                    } else if text == "Google" {
                        Text(text)
                            .font(.custom("Comfortaa-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: -20, y: 0)
                    } else {
                        Text(text)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: -10, y: 0)
                    }
                    
                    
                }
                .frame(width: 300, alignment: .center)
                .padding()
                .background(Theme.Peach)
                .cornerRadius(16)
            }
        }
    }

    struct LFButton_Previews: PreviewProvider {
        static var previews: some View {
            VStack {
                
                LFButton(
                    text: "Microsoft",
                    clicked: {
                        print("Clicked")
                    },
                    icon: Image("microsoftlogo")
                )
                
                LFButton(
                    text: "Google",
                    clicked: {
                        print("Clicked")
                    },
                    icon: Image("glogo2")
                )
                
            }
        }
    }

