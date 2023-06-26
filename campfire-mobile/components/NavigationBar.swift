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
            
            MapPage()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            CameraPage()
                .tabItem {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text("Camera")
                }
                .tag(2)
            
            SearchPage()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
        
        .accentColor(Theme.Peach)
    }
}
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(selectedTabIndex: .constant(nil))
    }
}

