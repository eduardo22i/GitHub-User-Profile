//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    static var url = "https://api.github.com/users/"
    
    static func getUserProfile(username: String) -> User {
        var user = User()
        
        let url = NSURL(string: "\(DataManager.url)\(username)")
        if let data = NSData(contentsOfURL: url!) {
            
            setKeysAndValues(user, dictionary: parseData(data))
        }
        
        return user
    }
    
    static func setKeysAndValues (object : AnyObject, dictionary : NSDictionary)  -> AnyObject  {
        
        for (key, value) in dictionary {
            if let keyName = key  as? String, let keyValue = value as? String {
                if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                    object.setValue(keyValue, forKey: keyName)
                }
            }
        }
        
        return object
        
    }
    
    static func parseData (data : NSData)  -> NSDictionary  {
        var error: NSError?
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
    }
}
