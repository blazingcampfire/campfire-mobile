//
//  HotspotsFeedPage.swift
//  campfire-mobile
//
//  Created by Adarsh G on 6/28/23.
//

import SwiftUI

struct HotspotsFeedPage: View {
    var body: some View {
        ZStack {
            TheFeed()
            
            VStack {
                Button(action: {
                    //go back to map page
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                }
            }
            .padding(.bottom, 700)
            .padding(.leading, 320)
    
        }
    }
}

struct HotspotsFeedPage_Previews: PreviewProvider {
    static var previews: some View {
        HotspotsFeedPage()
    }
}
