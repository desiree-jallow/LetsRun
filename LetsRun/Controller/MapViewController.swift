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
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var stopButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationAuthStatus()
        setPosition()
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let miles = (LocationService.instance.distanceInMeters / 1609)
        let kilo = LocationService.instance.distanceInKilo
        
        let formattedMiles = String(format: "%.02f", miles)
        let formattedKilo = String(format: "%.02f", kilo)
        
        
        if distanceSegment.selectedSegmentIndex == 0 {
            
            distanceLabel.text = "Your ran \(formattedMiles) Miles"
        } else {
            distanceLabel.text = "You ran \(formattedKilo) Kilometers"
        }
    }
    
    @IBAction func endButtonPressed(_ sender: RoundButton) {
        
        if let start = LocationService.instance.locationsArray.first, let end = LocationService.instance.locationsArray.last {
    
            setPosition()
            showRoute(startPosition: start, endPosition: end)
            LocationService.instance.locationManager.stopUpdatingLocation()
            stopButton.isEnabled = false
            stopButton.setTitleColor(.gray, for: .normal)
            distanceLabel.isHidden = false
            mapView.showsUserLocation = false
            
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
    
    func setPosition() {
        if let coordinate = LocationService.instance.locationManager.location?.coordinate {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
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
        directionsRenderer.strokeColor = #colorLiteral(red: 0.08059277385, green: 0.1894979179, blue: 0.3140477538, alpha: 1)
        directionsRenderer.lineWidth = 5
        directionsRenderer.alpha = 0.85
        
        return directionsRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        annotationView.animatesDrop = true
        annotationView.pinTintColor = #colorLiteral(red: 0.08059277385, green: 0.1894979179, blue: 0.3140477538, alpha: 1)
        
        return annotationView
        
        
    }
}


