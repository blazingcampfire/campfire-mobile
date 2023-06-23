//
//  NumberForm.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
import iPhoneNumberField

struct NumberForm: View {
    @State var text = ""
    @State var isEditing: Bool = false
    
    var body: some View {
        iPhoneNumberField(text: $text)
            .flagHidden(false)
            .flagSelectable(true)
            .font(UIFont(size: 25, weight: .light, design: .monospaced))
            .maximumDigits(20)
            .foregroundColor(Color.white)
            .clearButtonMode(.whileEditing)
            .onClear { _ in isEditing.toggle() }
            .accentColor(Color.orange)
            .padding()
            .background(Theme.Peach)
            .cornerRadius(10)
            .shadow(color: isEditing ? .gray : .white, radius: 10)
        
        
        
        
        
            .padding()
    }
}

struct NumberForm_Previews: PreviewProvider {
    static var previews: some View {
        NumberForm()
    }
}
