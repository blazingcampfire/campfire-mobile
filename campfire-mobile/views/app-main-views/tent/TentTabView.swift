//
//  SlidingTabView.swift
//  campfire-mobile
//
//  Created by Toni on 7/1/23.
//

import SwiftUI

// sliding tab view dependency from GitHub
import SlidingTabView
struct TentTabView: View {
    // this variable represents the index of each tab
    @State private var tabIndex = 0

    var body: some View {
        VStack {
            SlidingTabView(selection: $tabIndex, tabs: ["Notifications", "Search", "Requests"], font: .custom("LexendDeca-Regular", size: 15), animation: .easeInOut, activeAccentColor: Theme.Peach, selectionBarColor: Theme.Peach)
            Spacer()

            // conditional setup navigates to a different page depending on tab selection
            if tabIndex == 0 {
                NotificationsPage(range: 1 ... 12)
            } else if tabIndex == 1 {
                SearchPage()
            } else if tabIndex == 2 {
                RequestsPage()
            }
            Spacer()
        }
    }
}

struct TentTabView_Previews: PreviewProvider {
    static var previews: some View {
        TentTabView()
    }
}
