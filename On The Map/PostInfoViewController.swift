//
//  PostInfoViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostInfoViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var topBackground: UILabel!
    @IBOutlet weak var whereAreYou: UILabel!
    @IBOutlet weak var studying: UILabel!
    @IBOutlet weak var today: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomBackground: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    var myLocation : CLLocationCoordinate2D? = nil
    
    var session : NSURLSession!
    
    var theUser : ParseStudent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        prepareUI()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
    }
    
    @IBAction func submitButtonTouch(sender: AnyObject) {
        if let myLocation = myLocation {
            
            postThisLocation(myLocation)
            
        } else {
            findLocationOnMap(locationTextField.text!) { (coordinate, error) in
                if ( error != nil) {
                    self.showLocationNotFoundAlert()
                } else {
                    
                    self.myLocation = coordinate //next time touching this button will post the location
                    
                    self.changeUIafterSearch(coordinate)
                    
                    // Add pin on map
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate!
                    annotation.title = "I am here!"
                    
                    self.mapView.addAnnotation(annotation)
                    
                }
                
            }
        }
    }
    
    // This function calls the post method of ParseClient
    func postThisLocation(location: CLLocationCoordinate2D!) {
        
        // Complete ParseStudent object of user
        theUser.url = urlTextField.text!
        theUser.latitude = Float(location.latitude)
        theUser.longitude = Float(location.longitude)
        
        session = NSURLSession.sharedSession()
        
        ParseClient.sharedInstance().postStudentLocation(self.theUser, mapString: locationTextField.text!) { (success, errorString) in
            if success {
                // reload data
                // dismiss view
            } else {
                //display alert
            }
        }
    }
    
    // This function takes a string and finds the coordinate or return an error message
    func findLocationOnMap(string: String!, completionHandler: (coordinate: CLLocationCoordinate2D?, error: String?) ->  Void )  {
        
        let address = locationTextField.text!
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if((error) != nil){
                completionHandler(coordinate: nil, error: "error in geocoding" )

            } else {
                if let placemark = placemarks?.first {
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    completionHandler(coordinate: coordinates, error: nil )
                }
            }
        }
    }
    
    // UI setup and changes
    func prepareUI() {
        
        mapView.hidden = true
        
        urlTextField.hidden = true
        
        submitButton.setTitle("Find on the map", forState: UIControlState.Normal)
    }
    
    func changeUIafterSearch(location: CLLocationCoordinate2D!) {
        
        mapView.hidden = false
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        topBackground.backgroundColor = UIColor(red: 0/255, green: 96/255, blue: 183/255, alpha: 1)
        
        bottomBackground.hidden = true
        locationTextField.hidden = true
        
        submitButton.setTitle("Submit", forState: UIControlState.Normal)
        
        urlTextField.hidden = false
        
        whereAreYou.hidden = true
        studying.hidden = true
        today.hidden = true
    }
    
    func showLocationNotFoundAlert() {
        let alertController = UIAlertController(title: "Error", message:
            "Location Not Found!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
