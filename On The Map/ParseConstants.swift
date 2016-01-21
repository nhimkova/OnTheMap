//
//  ParseConstants.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct Constants {
        
        static let BaseURL : String = " http://www.udacity.com/api/"
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
    }
    
    struct Methods {
        
        static let Session = "session"
        static let Users = "users"
    }
    
    struct JSONResponseKeys {
        
        //Session
        static let Session = "session"
        static let SessionID = "id"
        
        //User ID
        static let Account = "account"
        static let UserID = "key"
        
    }
    
    
}