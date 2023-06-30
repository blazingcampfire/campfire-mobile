//
//  CustomNavView.swift
//  campfire-mobile
//
//  Created by Toni on 6/29/23.
//

import SwiftUI

struct TopNavBar<Content:View>: View {
    
    let content: Content
    
    init (@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            TopNavBarContainer {
                content
            }
        }
        .navigationBarHidden(true)
        .background(.clear)
    }

}

struct TopNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavBar {
            Color.red.ignoresSafeArea()
        }
    }
}
