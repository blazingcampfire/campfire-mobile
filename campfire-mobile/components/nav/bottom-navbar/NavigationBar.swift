//
//  NavigationBar.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
import SwiftUICam

struct NavigationBar: View {
    @EnvironmentObject var currentUser: CurrentUserModel
    @StateObject var feedModel = FeedPostModel()
    var body: some View {
        NavigationView {
        TabView() {
            TheFeed(postModel: feedModel)
                .tabItem {
                    Text("Feed")
                    Image(systemName: "fireplace")
                }
              
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            MapPage()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
            
           CameraView(currentUser: currentUser)
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("Camera")
                }
           
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            TentTabView()
                .environmentObject(currentUser)
                .tabItem {
                    Label("Tent", systemImage: "tent.fill")
                }
             
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
            
            OwnProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Theme.ScreenColor, for: .tabBar)
        }
        .accentColor(Theme.Peach)
        .onAppear {
            feedModel.getPosts()
        }
    }
        .navigationBarBackButtonHidden(true)
    }
}

//struct NavigationBar_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationBar()
//    }
//}
