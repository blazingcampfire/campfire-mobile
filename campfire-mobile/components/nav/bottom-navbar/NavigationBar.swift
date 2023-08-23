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
        TabView() {
            FeedViewControllerWrapper()
                .tabItem {
                    Image(systemName: "flame.circle.fill")
                }
                .environmentObject(currentUser)
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Color.black, for: .tabBar)
                .background(Color.black)
            
            
            CameraView(currentUser: currentUser, post: CamPostModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Color.black, for: .tabBar)
            
            SearchPage(model: SearchModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
            
            OwnProfilePage()
                .tabItem {
                    Image(systemName: "person.fill")
                }
            
//                .toolbar(.visible, for: .tabBar)
//                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
        }
        }

        .accentColor(Theme.Peach)
        .navigationBarBackButtonHidden(true)
    }
}
