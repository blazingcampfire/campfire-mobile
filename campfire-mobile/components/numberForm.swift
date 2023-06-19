//
//  numberForm.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
import iPhoneNumberField

struct numberForm: View {
    @State var text = ""
    var body: some View {
        iPhoneNumberField("Phone", text: $text)
            .flagHidden(false)
            .flagSelectable(true)
            .font(UIFont(size: 30, weight: .bold, design: .default))
            .padding()
    }
}

struct numberForm_Previews: PreviewProvider {
    static var previews: some View {
        numberForm()
    }
}
