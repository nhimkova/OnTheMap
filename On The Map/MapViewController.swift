//
//  MapViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var students = [ParseStudent]()
    var annotations = [MKPointAnnotation]()
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //1. load students from parse API
        session = NSURLSession.sharedSession()
        
        ParseClient.sharedInstance().downloadStudentLocations() { (success, data, errorString) in
            
            if success {
                self.students = ParseStudent.studentsFromResults(data!)
                
                //2. create annotations
                for student in self.students {
                    
                    let annotation = MKPointAnnotation()
                    let lat = CLLocationDegrees(student.latitude!)
                    let long = CLLocationDegrees(student.longitude!)
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    annotation.title = student.firstName + " " + student.lastName
                    annotation.subtitle = student.url
                    self.mapView.addAnnotation(annotation)
                }

            } else {
                print(errorString)
            }
        }
        
    }
    
}
