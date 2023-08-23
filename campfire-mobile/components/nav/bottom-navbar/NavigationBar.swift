//
//  NavigationBar.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct NavigationBar: View {
    @EnvironmentObject var currentUser: CurrentUserModel

    var body: some View {
        NavigationView {
            TabView {
                FeedViewControllerWrapper()
                    .tabItem {
                        Image(systemName: "flame.circle.fill")
                    }
                    .environmentObject(currentUser)
                    .background(Color.black)

                CameraView(post: CamPostModel(currentUser: currentUser))
                    .tabItem {
                        Image(systemName: "camera")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }

                SearchPage(model: SearchModel(currentUser: currentUser))
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }

                OwnProfilePage()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
            }
        }

        .accentColor(Theme.Peach)
        .navigationBarBackButtonHidden(true)
    }
}
