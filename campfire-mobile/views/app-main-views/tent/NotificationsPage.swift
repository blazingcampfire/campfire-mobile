//
//  NotificationsPage.swift
//  campfire-mobile
//
//  Created by Toni on 6/30/23.
//

import SwiftUI

struct NotificationsPage: View {
    
    @EnvironmentObject var notificationsManager: NotificationsManager

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            Button("Request Notification Permission") {
                Task {
                    await notificationsManager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(notificationsManager.hasPermission)
        }
        .task {
            await notificationsManager.getAuthStatus()
            await notificationsManager.addNotification()
        }
        
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage()
    }
}
