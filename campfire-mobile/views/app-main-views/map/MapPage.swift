//
//  MapPage.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/19/23.
//

import MapKit
import SwiftUI

struct MapPage: View {
    @State var region =
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.316322, longitude: -72.922340), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

    var body: some View { // whole screen
        VStack {
            Map(coordinateRegion: $region).edgesIgnoringSafeArea(.top)
        }
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage()
    }
}
