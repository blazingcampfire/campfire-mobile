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
                        icon
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 10)
                    }

                    Text(text)
                        .font(.custom("Futura-Bold", size: 25))
                        .foregroundColor(.white)
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
            LFButton(
                text: "Create Account",
                clicked: {
                    print("Clicked")
                },
                icon: Image(systemName: "glogo2") // Replace with your image name
            )
        }
    }

