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
    
    var students = [ParseStudent]()
    var session : NSURLSession!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        let tab = self.tabBarController as? TabNavigationViewController
        
        tab?.reloadStudentLocation() { (success) in
            
            if success {
                self.refreshTable()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.students.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell")!
        let student = self.students[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.url
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let app = UIApplication.sharedApplication()
        let toOpen = students[indexPath.row].url
        if let url = NSURL(string: toOpen) {
            app.openURL(url)
        } else {
            displayAlert("Error", message: "Could not open URL")
        }
    }
    
    func displayAlert(title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refreshTable() {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.students = appDelegate.students
        
        tableView.reloadData()
    }

    
}

