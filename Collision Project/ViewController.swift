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
    @IBOutlet weak var speedLabel: UILabel!
    
    var movedToUserLocation = false
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            manager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        let depthBound = 2.0 as NSNumber
        
        
        let testlat = 63.4313892
        let testlng = 10.4050155
        
        let initlat = 63.415102
        let initlng = 10.406444
        
        let offlat = testlat - initlat
        let offlng = testlng - initlng
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        let strtest = "http://188.166.59.108:3000/api/v1/test?lat=\(location.coordinate.latitude + offlat)&lng=\(location.coordinate.longitude + offlng)&vel=100&bearing=0"
        //let strtest = "http://188.166.59.108:3000/api/v1/test?lat=\(testlat)&lng=\(testlng)&vel=10&bearing=0"
        let url = URL(string: strtest)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil     {
                print("WARNING!")
            }
            else {
                if let content = data   {
                    do     {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(myJson)
                        
                        if let minima = myJson["min"] as? NSNumber   {
                            if (minima.floatValue < depthBound.floatValue) {
                                DispatchQueue.main.async( execute: {
                                    self.Warning.text = "WARNING!!!"
                                })
                            }
                            else {
                                DispatchQueue.main.async( execute: {
                                    self.Warning.text = "Safe"
                                })
                            }
                        }
                        if let maxima = myJson["max"] as? NSNumber   {
                            print("\(maxima)")
                            
                        }
                        
                    }
                    catch {print("Error")}
                }
            }
        }
        task.resume()
        
        speedLabel.text = "Speed = \(location.speed.rounded()) m/s"
        //let val = myJson
        //speedLabel.text = "\(val)"
        
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

