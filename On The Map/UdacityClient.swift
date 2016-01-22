//
//  UdacityClient.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Configuration object */
    //var config = UdacityConfig()
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    var lastName : String? = nil
    var firstName : String? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        sessionID = nil
        userID = nil
        lastName = nil
        firstName = nil
        
        super.init()
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
            
        }
        
        return Singleton.sharedInstance
    }
}