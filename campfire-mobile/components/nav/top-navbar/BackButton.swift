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
            Text("back")
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        Button {
        } label: {
            Text("back")
        }
    }
}
