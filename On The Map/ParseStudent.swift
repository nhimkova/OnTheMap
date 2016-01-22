//
//  ParseStudent.swift
//  On The Map
//
//  Created by Quynh Tran on 21/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

struct ParseStudent {
    
    var firstName = ""
    var lastName = ""
    var url = ""
    var latitude : Float? = nil
    var longitude : Float? = nil
    var userID = ""
    
    init(dictionary: [String : AnyObject?]) {
        
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
        url = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Float
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Float
        userID = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as! String
    }
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [ParseStudent] {
        var students = [ParseStudent]()
        
        for result in results {
            students.append(ParseStudent(dictionary: result))
        }
        
        return students
    }

}
