//
//  LocationHandler.swift
//  campfire-mobile
//
//  Created by Femi Adebogun on 8/5/23.
//

import SwiftUI
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func getLocation() {
        self.locationManager.startUpdatingLocation()
    }

    func getAddress(completion: @escaping (String?) -> Void) {
        guard let currentLocation = self.currentLocation else {
            return completion(nil)
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            
            if let placemark = placemarks?.first {
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                let cityName = placemark.locality ?? ""
                let locationString = "\(streetNumber) \(streetName), \(cityName)"
                completion(locationString)
            }
        }
    }
    
    // Delegate function that will be called whenever the device's location is updated.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
    }
}
