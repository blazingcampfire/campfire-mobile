//
//  CustomNavView.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct TopNavBar<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack {
            TopNavBarContainer {
                content
            }
        }
        .navigationBarHidden(true)
        .background(.clear)
    }
}
