//
//  MapViewController.swift
//  LetsRun
//
//  Created by Desiree on 9/24/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
   
    

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationAuthStatus()
        setStartPosition()
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func endButtonPressed(_ sender: RoundButton) {
        LocationService.instance.locationManager.stopUpdatingLocation()
        
        
        if let start = LocationService.instance.locationsArray.first, let end = LocationService.instance.locationsArray.last {
            
            showRoute(startPosition: start, endPosition: end)
        }
        
    }
    
}

extension MapViewController {
    func showRoute(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startPosition))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endPosition))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self](response, error) in
            guard let route = response?.routes.first else {return}
            self.mapView.addOverlay(route.polyline)
            
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 200, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
    
    func setStartPosition() {
        if let coordinate = LocationService.instance.locationManager.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Start"
            mapView.addAnnotation(annotation)
            
        }
    }
    
    func checkLocationAuthStatus() {
        if LocationService.instance.locationManager.authorizationStatus == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.mapView.userTrackingMode = .follow
        } else {
            LocationService.instance.locationManager.requestWhenInUseAuthorization()
        }
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let directionsRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        directionsRenderer.strokeColor = .systemBlue
        directionsRenderer.lineWidth = 5
        directionsRenderer.alpha = 0.85
        
        return directionsRenderer
    }
}


