//
//  MapPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import SwiftUI
import MapKit

struct MapPage: View {
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.316322, longitude: -72.922340), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    var body: some View {
        VStack {
            Image(systemName: "fireplace")
                .font(.system(size: 50))
                .padding(.top, 5)
                .foregroundColor(Theme.Peach)

            Map(coordinateRegion: $region)
                

            
        }
    }
}


struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
    }
}
