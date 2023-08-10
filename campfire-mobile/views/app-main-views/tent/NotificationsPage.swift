//
//  NotificationsPage.swift
//  campfire-mobile
//
//  Created by Toni on 6/30/23.
//

import SwiftUI

struct NotificationsPage: View {
    

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            Button("Request Notification Permission") {
                Task {
                    await NotificationsManager.shared.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(NotificationsManager.shared.hasPermission)
        }
        .task {
            await NotificationsManager.shared.getAuthStatus()
        }
        
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage()
    }
}
