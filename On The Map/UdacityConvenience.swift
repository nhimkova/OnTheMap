//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {
    
    func authenticateWithViewController(email: String!, password: String!, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.createSession(email, password: password) { (success, sessionID, userID, errorString) in
            if success {
                print(sessionID)
                print(userID)
                self.sessionID = sessionID
                self.userID = userID
            }
            completionHandler(success: success, errorString: errorString)
        }
    }
    
    func createSession(email: String!, password: String!, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "error in createSession")
                return
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
                var parsedResult : NSDictionary?
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary
                } catch {
                    parsedResult = nil
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Cannot parse data.")
                    return
                }
                
                let sessionData = parsedResult![UdacityClient.JSONResponseKeys.Session]
                let userData = parsedResult![UdacityClient.JSONResponseKeys.Account]
                if let sessionID = sessionData![UdacityClient.JSONResponseKeys.SessionID] as? String {
                    if let userID = userData![UdacityClient.JSONResponseKeys.UserID] as? String {
                        completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                    } else {
                        completionHandler(success: false, sessionID: sessionID, userID: nil, errorString: "error createSession (User ID)")
                    }
                } else {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "error createSession (Session ID)")
                }
                }
            }
        task.resume()
        
    }
    
}
