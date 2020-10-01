//
//  LocationService.swift
//  LetsRun
//
//  Created by Desiree on 9/28/20.
//

import Foundation
import CoreLocation
import MapKit


class LocationService: NSObject, CLLocationManagerDelegate {
    static let instance = LocationService()
    
    var locationManager = CLLocationManager()
    var locationsArray: [CLLocationCoordinate2D] = []
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last?.coordinate {
            locationsArray.append(location)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
