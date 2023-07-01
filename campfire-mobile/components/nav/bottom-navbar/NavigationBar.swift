//
//  NavigationBar.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
struct NavigationBar: View {
    @Binding var selectedTabIndex: Int?

        
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            TheFeed()
                .tabItem {
                    Text("Feed")
                    Image(systemName: "fireplace")
                    
                }
                .tag(0)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            MapPage()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.init(white: 1), for: .tabBar)
            
            CameraPage()
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("Camera")
                }
                .tag(2)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.black, for: .tabBar)
            
            SearchPage()
                .tabItem {
                    Label("Tent", systemImage: "tent.fill")
                       
                }
                .tag(3)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.init(white:1), for: .tabBar)
            
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.init(white: 1), for: .tabBar)
        }
        .accentColor(Theme.Peach)
        
    }
}
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(selectedTabIndex: .constant(nil))
    }
}

