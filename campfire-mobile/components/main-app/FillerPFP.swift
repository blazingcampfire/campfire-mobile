//
//  FillerPFP.swift
//  campfire-mobile
//
//  Created by Adarsh G on 8/12/23.
//

import SwiftUI

struct FillerPFP: View {
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .foregroundColor(Theme.Peach)
            .frame(width: 120, height: 120)
            .clipShape(Circle())
        
            .background(Color.white)
            .clipShape(Circle())
    }
}
