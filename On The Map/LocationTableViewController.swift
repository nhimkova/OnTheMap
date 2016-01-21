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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        students = appDelegate.students
        tableView.reloadData()
        
        tabBarController?.tabBar.hidden = false
        
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
        
        /* Push the web view */
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        controller.student = students[indexPath.row]
        //self.navigationController!.pushViewController(controller, animated: true)
        
        let webNavigationController = UINavigationController()
        webNavigationController.pushViewController(controller, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(webNavigationController, animated: true, completion: nil)
        })
        
    }
    
    
    
}

