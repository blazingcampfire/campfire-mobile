//
//  MapHotspots.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 6/25/23.
//

import Foundation
import MapKit


struct MapHotspots {
    var location: [CLLocationDegrees] //array of location coordinates
    var feedImages: [String] //array of image or video urls
    // Button that on tap shows you images from the hotspot
    // If three posts have been made within small radius, then hotspot button appears
}
