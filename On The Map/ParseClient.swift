//
//  ParseClient.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil
    
    // MARK: Initializers
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        return NSURLSessionDataTask()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}