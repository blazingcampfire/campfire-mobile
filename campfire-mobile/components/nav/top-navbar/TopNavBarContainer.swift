//
//  TopNavBarContainer.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct TopNavBarContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            CustomTopNavBar()
            Spacer()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.clear)
    }
}
