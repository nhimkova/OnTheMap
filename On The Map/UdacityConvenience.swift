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
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Connection Failure")
                return
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
                var parsedResult : NSDictionary?
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary
                } catch {
                    parsedResult = nil
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Wrong Email Or Password")
                    return
                }
                
                if let sessionData = parsedResult![UdacityClient.JSONResponseKeys.Session] {
                    if let userData = parsedResult![UdacityClient.JSONResponseKeys.Account] {
                        if let sessionID = sessionData[UdacityClient.JSONResponseKeys.SessionID] as? String {
                            if let userID = userData[UdacityClient.JSONResponseKeys.UserID] as? String {
                                completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                                return
                            } //end userID
                        } //end sessionID
                    } //end userData
                } //end sessionData
                
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Wrong Email Or Password")
                
            } //end else error nil
        } //end task
        task.resume()
        
    } // end creaseSession
    
    func getUserInfo(userID: String!, completionHandler__: (success: Bool, lastName: String?, nickName: String?, errorString: String?) -> Void) {
        
        let urlString = UdacityClient.Constants.BaseURLSecure + UdacityClient.Methods.Users + "/" + userID
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler__(success: false, lastName: nil, nickName: nil, errorString: "error getting user info")
                return
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                
                var parsedResult : NSDictionary?
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? NSDictionary
                } catch {
                    parsedResult = nil
                    completionHandler__(success: false, lastName: nil, nickName: nil, errorString: "cannot parse data")
                    return
                }
                
                if let userData = parsedResult![UdacityClient.JSONResponseKeys.User] {
                    if let lastName = userData[UdacityClient.JSONResponseKeys.LastName] as? String {
                        if let nickName = userData[UdacityClient.JSONResponseKeys.NickName] as? String {
                            completionHandler__(success: true, lastName: lastName, nickName: nickName, errorString: nil)
                            return
                        } // end nickName
                    } // end lastName
                } // end userData
                
                completionHandler__(success: false, lastName: nil, nickName: nil, errorString: "error in getUserInfo (JSON not consistent)")
    
            } //end else if no error
        }
        
        task.resume()
    }
    
    func deleteSession() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}
