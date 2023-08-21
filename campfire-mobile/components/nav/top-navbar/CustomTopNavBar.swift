//
//  CustomTopNavBar.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct CustomTopNavBar: View {
    @State private var title: String = "campfire"

    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.custom("LexendDeca-Bold", size: 20))
            Spacer()
        }
        .foregroundColor(Theme.Peach)
        .background(.clear)
    }
}
