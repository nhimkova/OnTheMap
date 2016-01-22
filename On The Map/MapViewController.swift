//
//  MapViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UINavigationBarDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var students = [ParseStudent]()
    var annotations = [MKPointAnnotation]()
    var session: NSURLSession!
    
    var theUser : ParseStudent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar()
        
        mapView.delegate = self
        
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        reloadStudentLocation()
                
        
    }
    
    func reloadStudentLocation() {
        
        session = NSURLSession.sharedSession()
        
        ParseClient.sharedInstance().downloadStudentLocations() { (success, data, errorString) in
            
            if success {
                self.students = ParseStudent.studentsFromResults(data!)
                
                //2. Save as global variable
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                appDelegate.students = self.students
                
                self.reloadAnnotations()
                
            } else {
                print(errorString)
            }
        }
    }
    
    func reloadAnnotations() {
        
        for student in self.students {
            
            let annotation = MKPointAnnotation()
            let lat = CLLocationDegrees(student.latitude!)
            let long = CLLocationDegrees(student.longitude!)
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.url
            self.annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    // Map View Protocols
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.purpleColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    // Nav bar configuration
    
    func configNavBar() {
        
        self.parentViewController!.navigationController!.navigationBar.topItem!.title = "On the map"
        
        let refreshButton =  UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reloadStudentLocation")
        let postButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "postInformation")
        
        self.parentViewController!.navigationItem.setRightBarButtonItems([postButton, refreshButton], animated: false)

    }
    
    func postInformation() {
        
        /* Push the web view */
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PostInfoViewController") as! PostInfoViewController
        
        // Prepare ParseStudent object
        let dictionary : [String: AnyObject?] = [
            ParseClient.JSONResponseKeys.FirstName : UdacityClient.sharedInstance().firstName,
            ParseClient.JSONResponseKeys.LastName : UdacityClient.sharedInstance().lastName,
            ParseClient.JSONResponseKeys.MediaURL : "",
            ParseClient.JSONResponseKeys.Latitude : nil,
            ParseClient.JSONResponseKeys.Longitude : nil,
            ParseClient.JSONResponseKeys.UniqueKey : UdacityClient.sharedInstance().userID
        ]
        
        controller.theUser = ParseStudent(dictionary: dictionary)
        
        let postNavigationController = UINavigationController()
        postNavigationController.pushViewController(controller, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(postNavigationController, animated: true, completion: nil)
        })
    }
    
    
}
