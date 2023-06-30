//
//  CustomTopNavBar.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct CustomTopNavBar: View {
    
    @State private var title: String = "search"
    @State private var iconName: String = "magnifyingglass.circle.fill"
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: iconName)
                .font(.system(size: 24))
            Text(title)
                .font(.custom("LexendDeca-Bold", size: 20))
            Spacer()
        }
        .foregroundColor(Theme.Peach)
    }
}

struct CustomTopNavBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomTopNavBar()
            Spacer()
        }
    }
}
