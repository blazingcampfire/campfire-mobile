//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(.init(red: 255/255, green: 50/255, blue: 89/255, alpha: 1)), Color(.init(red: 255/255, green: 153/255, blue: 102/255, alpha: 1))]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                ZStack {
                })
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}