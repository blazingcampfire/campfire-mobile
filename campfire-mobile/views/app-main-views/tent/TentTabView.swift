//
//  SlidingTabView.swift
//  campfire-mobile
//
//  Created by Toni on 7/1/23.
//

import SwiftUI
import SlidingTabView

struct TentTabView: View {
    // this variable represents the index of each tab
    @State private var tabIndex: Int = 0
    @EnvironmentObject var currentUser: CurrentUserModel
    
    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            
            VStack {
                SlidingTabView(selection: $tabIndex, tabs: ["search", "requests"], font: .custom("LexendDeca-Bold", size: 15), animation: .easeInOut, activeAccentColor: Theme.Peach, inactiveAccentColor: .gray, selectionBarColor: Theme.Peach)
                
                
                Spacer()
                
                // conditional setup navigates to a different page depending on tab selection
                if tabIndex == 0 {
                    SearchPage(model: SearchModel(currentUser: currentUser))
                } else if tabIndex == 1 {
                    RequestsPage(model: RequestsModel(currentUser: currentUser))
                }
                Spacer()
            }
        }
    }
}

struct TentTabView_Previews: PreviewProvider {
    static var previews: some View {
        TentTabView()
    }
}
