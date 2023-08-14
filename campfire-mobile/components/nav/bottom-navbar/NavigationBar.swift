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
            ScrollFeed(feedModel: FeedPostModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "flame.circle.fill")
                }

                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            MapPage()
                .tabItem {
                    Image(systemName: "map")
                }
            
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
            
            CameraView(currentUser: currentUser, post: CamPostModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
           
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            SearchPage(model: SearchModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
             
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
            
            OwnProfilePage()
                .tabItem {
                    Image(systemName: "person.fill")
                }
            
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
        }
        .accentColor(Theme.Peach)
    }
        .navigationBarBackButtonHidden(true)
    }
}

//struct NavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationBar()
//
//    }
//}
