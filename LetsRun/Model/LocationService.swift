//
//  LocationService.swift
//  LetsRun
//
//  Created by Desiree on 9/28/20.
//

import Foundation
import CoreLocation
import MapKit

protocol CustomUserLocDelegate {
    func userLocationUpdated(location: CLLocation)
    
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let instance = LocationService()
    
    var customUserLocDelegate: CustomUserLocDelegate?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = manager.location?.coordinate
        
        if customUserLocDelegate != nil {
            customUserLocDelegate?.userLocationUpdated(location: locations.first!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    

}
