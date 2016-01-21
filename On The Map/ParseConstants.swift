//
//  ParseConstants.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

extension ParseClient {
    
    struct Constants {
        
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let BaseURLSecure = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct HTTPHeaderField {
        
        static let apiHeader = "X-Parse-REST-API-Key"
        static let appIDHeader = "X-Parse-Application-Id"
    }
    
    struct JSONResponseKeys {
        
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let UpdatedAt = "updatedAt"
        
    }
    
    
}