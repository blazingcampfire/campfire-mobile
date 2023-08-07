//
//  NotificationsPage.swift
//  campfire-mobile
//
//  Created by Toni on 6/30/23.
//

import SwiftUI

struct NotificationsPage: View {
    let range: ClosedRange<Int>

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            List {
                    ForEach(range, id: \.self) { _ in
                        ZStack {
                            Theme.ScreenColor
                                .ignoresSafeArea(.all)
                            
                            VStack {
                                Notification()
                                Divider()
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
        }
        
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(range: 1 ... 12)
    }
}
