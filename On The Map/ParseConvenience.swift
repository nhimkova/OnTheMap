//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClient {
    
    func downloadStudentLocations(completionHandler: (success: Bool, data: [[String : AnyObject]]?, errorString: String?) -> Void) {
        
        let methodArguments : [String : AnyObject] = [
            parameterKeys.Limit : 100,
            parameterKeys.Order : "-" + JSONResponseKeys.UpdatedAt
        ]
        
        let urlString = ParseClient.Constants.BaseURLSecure + ParseClient.escapedParameters(methodArguments)
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
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
                } catch {
                    completionHandler(success: false, data: nil, errorString: "Could not parse the data as JSON: downloadStudentLocations")
                    return
                }
                
                if let newData = parsedResult!["results"] as? [[String : AnyObject]] {
                    
                    completionHandler(success: true, data: newData, errorString: "")
                    
                } else {
                    completionHandler(success: false, data: nil, errorString: "No result in JSON")
                }
            }
        }
        
        task.resume()
    }
    
    func postStudentLocation(user: ParseStudent!, mapString: String!, completionHandler: (success: Bool, errorString: String?) -> Void ) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseClient.Constants.BaseURLSecure)!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.appID, forHTTPHeaderField: ParseClient.HTTPHeaderField.appIDHeader)
        request.addValue(ParseClient.Constants.apiKey, forHTTPHeaderField: ParseClient.HTTPHeaderField.apiHeader)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpbodyString = "{\"uniqueKey\": \"\(user.userID)\", \"firstName\": \"\(user.firstName)\", \"lastName\": \"\(user.lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(user.url)\",\"latitude\": \(user.latitude!), \"longitude\": \(user.longitude!)}"
        
        request.HTTPBody = httpbodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, errorString: "error in postStudentLocation")
                return
            }

            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            completionHandler(success: true, errorString: nil)
        }
        task.resume()
        
        
    }
    
    
    
}