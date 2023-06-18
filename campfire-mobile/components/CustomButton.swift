//
//  SwiftUIView.swift
//  campfire-mobile
//
//  Created by Toni on 6/17/23.
//

import SwiftUI

struct CustomButton: View {
    var body: some View {
        Button {
        } label: {
            Text("start")
                .padding().foregroundColor(.black)
                .background {
                    Capsule()
                        .stroke(.black, lineWidth: 4)
                        .saturation(1.8)
                }
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
