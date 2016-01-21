//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func downloadStudentLocations(completionHandler: (success: Bool, data: [[String : AnyObject]]?, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseURLSecure)!)
        request.addValue(ParseClient.Constants.appID, forHTTPHeaderField: ParseClient.HTTPHeaderField.appIDHeader)
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: ParseClient.HTTPHeaderField.apiHeader)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, data: nil, errorString: "error in getting data for downloadStudentLocations")
            } else {
                var parsedResult: AnyObject?
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    let newData = parsedResult!["results"] as! [[String : AnyObject]]
                    
                    completionHandler(success: true, data: newData, errorString: "")
                } catch {
                    completionHandler(success: false, data: nil, errorString: "Could not parse the data as JSON: downloadStudentLocations")
                }
            }
        }
        
        task.resume()
    }
    
    func postStudentLocation() {
        
        
    }
    
    
    
}