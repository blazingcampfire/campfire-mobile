//
//  CustomTopNavBar.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct CustomTopNavBar: View {
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "sun.max.fill")
            Text("campfire")
                .font(.custom("LexendDeca-Bold", size: 20))
            Spacer()
        }
        .background(.white)
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
