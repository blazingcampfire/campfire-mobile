//
//  NotificationsPage.swift
//  campfire-mobile
//
//  Created by Toni on 6/30/23.
//

import SwiftUI

struct NotificationsPage: View {
    
    @StateObject private var manager = NotificationsManager()

    var body: some View {
        ZStack {
            Theme.ScreenColor
                .ignoresSafeArea(.all)
            Button("Request Notification Permission") {
                Task {
                    await manager.request()
                }
            }
            .buttonStyle(.bordered)
            .disabled(manager.hasPermission)
        }
        .task {
            await manager.getAuthStatus()
        }
        
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage()
    }
}
