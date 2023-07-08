//
//  BackButton.swift
//  campfire-mobile
//
//  Created by Toni on 7/7/23.
//

import SwiftUI

struct BackButton: View {
    
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "arrowshape.backward.fill")
                .foregroundColor(.white)
                .font(.system(size: 10))
            Text("back")
                .font(.custom("LexendDeca-Bold", size: 20))
                .foregroundColor(.white)
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Image(systemName: "arrowshape.backward.fill")
                .foregroundColor(Theme.Peach)
                .font(.system(size: 25))
            Text("back")
                .font(.custom("LexendDeca-Bold", size: 20))
        }
    }
}
