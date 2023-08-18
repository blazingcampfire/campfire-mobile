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
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.black, for: .tabBar)
                    .background(Color.black)
            
            
            CameraView(currentUser: currentUser, post: CamPostModel(currentUser: currentUser))
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
           
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            TentTabView()
                .environmentObject(currentUser)
                .tabItem {
                    Image(systemName: "tent.fill")
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
