//
//  LocationService.swift
//  LetsRun
//
//  Created by Desiree on 9/28/20.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    static let instance = LocationService()
    
    var locationManager = CLLocationManager()
    var locationsArray: [CLLocationCoordinate2D] = []
    
    var distanceInMeters = 0.0
    var distanceInKilo = 0.0
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let singleLocation = locations.last?.coordinate {
            locationsArray.append(singleLocation)
        }
        
        if let firstLat = locationsArray.first?.latitude,
           let firstLong = locationsArray.first?.longitude,
           let lastLat = locationsArray.last?.latitude,
           let lastLong = locationsArray.last?.longitude {
            
            let startLocation = CLLocation(latitude: firstLat , longitude: firstLong)
            let endLocation = CLLocation(latitude: lastLat, longitude: lastLong )
           
             distanceInMeters = startLocation.distance(from: endLocation)
             distanceInKilo = distanceInMeters / 1000
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
