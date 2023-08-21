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
    var icon: Image?
    var action: (() -> Void)?
    
    var body: some View {
                HStack {
                    if let icon = icon {
                        if icon == Image("glogo2") {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 30)
                                .offset(x: -42, y: 0)
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
                                
                        }
                            
                    }
                    
                    if text == "Microsoft"{
                        Text(text)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: -11, y: 0)
                    } else if text == "Google" {
                        Text(text)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: -22, y: 0)
                    } else {
                        Text(text)
                            .font(.custom("LexendDeca-Bold", size: 25))
                            .foregroundColor(.white)
                            .offset(x: 0, y: 0)
                    }
                    
                    
                }
                .frame(width: 300, height: 30, alignment: .center)
                .padding()
                .background(Theme.Peach)
                .cornerRadius(16)
            }
        }
