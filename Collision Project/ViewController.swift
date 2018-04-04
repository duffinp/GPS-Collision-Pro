//
//  ViewController.swift
//  Collision Project
//
//  Created by Paul Duffin on 21/03/2018.
//  Copyright © 2018 Illuminati. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Warning: UILabel!
    
    var movedToUserLocation = false
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let initial_Location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(63.415, 10.406)
        
                mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.mapView.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("We need user location.")
        case .restricted:
            print("User location is restricted. Change settings")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            manager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !movedToUserLocation {
            mapView.region.center = mapView.userLocation.coordinate
            let distanceSpan:CLLocationDegrees = 2000
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.region.center, distanceSpan, distanceSpan), animated: true)
            movedToUserLocation = true
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

