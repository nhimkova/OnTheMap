//
//  TabNavigationViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 22/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation
import UIKit

class TabNavigationViewController : UITabBarController {
    
    var session : NSURLSession!
    
    override func viewDidLoad() {
        
        configNavBar()
    }
    
    func configNavBar() {
        
        self.navigationController!.navigationBar.topItem!.title = "On the map"
        
        let refreshButton =  UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refresh")
        
        let postButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "postInformation")
        
        self.navigationItem.setRightBarButtonItems([postButton, refreshButton], animated: false)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
    }
    
    func refresh() {
        
        reloadStudentLocation() { (success) in
            
            if success {
                
                if self.selectedViewController!.isKindOfClass(MapViewController) {
                    
                    let controller = self.selectedViewController as! MapViewController
                    
                    controller.refreshMap()
                    
                } else if self.selectedViewController!.isKindOfClass(LocationTableViewController){
                    let controller = self.selectedViewController as! LocationTableViewController
                    
                    controller.refreshTable()
                    
                } else {
                    
                    self.displayAlert("Error", message: "Could Not Refresh Data")
                    
                }
            } //end success
        } //end reloadStudentLocation
    }
    
    func reloadStudentLocation(completionHandler: (success: Bool) ->Void ) {
        
        session = NSURLSession.sharedSession()
        
        ParseClient.sharedInstance().downloadStudentLocations() { (success, data, errorString) in
            
            if success {
                
                // Save student data as global variable
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                
                let students = ParseStudent.studentsFromResults(data!)

                appDelegate.students = students
                
                completionHandler(success: true)
                
            } else {
                self.displayAlert("Error", message: "Could Not Load Student Data")
                
                print(errorString)
                
                completionHandler(success: false)
            }
        }
    }
    
    func logout() {
        
        UdacityClient.sharedInstance().deleteSession()
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
        
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
    
    func displayAlert(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}