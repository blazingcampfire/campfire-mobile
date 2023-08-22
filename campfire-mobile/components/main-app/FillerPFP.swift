//
//  FillerPFP.swift
//  campfire-mobile
//
//  Created by Adarsh G on 8/12/23.
//

import SwiftUI

struct FillerPFP: View {
    
    var size = 100.0
    
    var body: some View {
        

            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(Color.white)
                .background(Theme.Peach)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 15)
                        .frame(width: 120.0, height: 120.0)
                )
                .clipShape(Circle())
        }
    }

