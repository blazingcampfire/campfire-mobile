//
//  MapPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI

struct MapPage: View {
    var body: some View {
        VStack {
            ZStack {
                VStack {
                Image(systemName: "fireplace")
                    .font(.system(size: 55))
                    .foregroundColor(Theme.Peach).padding(1).offset(x:0, y: 0)
                
                Spacer()
                
                Image("googlemap").resizable().aspectRatio(contentMode: .fill).frame(width: 400, height: 600)
            }
        }
        NavigationBar()
    }
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
    }
}
