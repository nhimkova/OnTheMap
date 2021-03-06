//
//  LocationTableViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewController: UITableViewController {
    
    var session : NSURLSession!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        let tab = self.tabBarController as? TabNavigationViewController
        
        tab?.reloadStudentLocation() { (success) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshTable()
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let students = Parse.students {
            return students.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell")!
        
        if let students = Parse.students {
            
            let student = students[indexPath.row]
        
            // Set the name and image
            cell.textLabel?.text = student.firstName + " " + student.lastName
            cell.detailTextLabel!.text = student.url
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        if let students = Parse.students {
            let toOpen = students[indexPath.row].url
            if let url = NSURL(string: toOpen) {
                app.openURL(url)
            } else {
                displayAlert("Error", message: "Could not open URL")
            }
        }
    }
    
    func displayAlert(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refreshTable() {

        tableView.reloadData()
        print("table reloaded")
    }

    
}

