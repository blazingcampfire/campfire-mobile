//
//  NavigationBar.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
struct NavigationBar: View {
    var body: some View {
        TabView {
            Text("Feed")
                .tabItem {
                    Label("Feed", systemImage: "person.2.fill")
                }
            Text("Map")
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            Text("Camera")
                .tabItem {
                Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                Text("Camera")
                }
            
            Text("Search")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.red)
    }
}
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar()
    }
}

