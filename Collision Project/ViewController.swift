//
//  ViewController.swift
//  Collision Project
//
//  Created by Paul Duffin on 21/03/2018.
//  Copyright © 2018 Illuminati. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initial_Location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(63.415, 10.406)
        //let initial_Location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(64.102031, -21.776083)
        let distanceSpan:CLLocationDegrees = 2000
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(initial_Location, distanceSpan, distanceSpan), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

