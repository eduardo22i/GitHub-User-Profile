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
    
    static func getUser(username: String) -> User {
        var user = User()
        
        let url = NSURL(string: "\(DataManager.url)\(username)")
        if let data = NSData(contentsOfURL: url!) {
            
            setKeysAndValues(user, dictionary: parseData(data))
        }
        
        return user
    }
    
    
    static func getRepos(username: String) -> [Repo] {
        var repos = [Repo()]
        
        let url = NSURL(string: "\(DataManager.url)\(username)/repos")
        if let data = NSData(contentsOfURL: url!) {
            //println(parseDataArray(data)[0]["archive_url"]!)
            for repoDic in parseDataArray(data) {
                //println(repoDic["archive_url"])
                if let repoDic = repoDic as? NSDictionary {
                    if let repo = setKeysAndValues(Repo(), dictionary: repoDic) as? Repo {
                        repos.append(repo)
                    }
                }
            }
        }
        repos.removeAtIndex(0)
        return repos
    }
    
    static func setKeysAndValues (object : AnyObject, dictionary : NSDictionary)  -> AnyObject  {
        
        for (key, value) in dictionary {
           
            if !(key as! String == "description") {
                if let keyName = key  as? String {
                    if let keyValue = value as? String {
                        if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                            object.setValue(keyValue, forKey: keyName)
                        }
                    }
                    if let keyValue = value as? Int {
                        if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                            object.setValue(keyValue, forKey: keyName)
                        }
                    }
                }
            } else {
                let key = "alternateDescription"
                if (object.respondsToSelector(NSSelectorFromString(key))) {
                    object.setValue(value, forKey: key)
                }
            }
            
        }
        
        return object
        
    }
    
    static func parseData (data : NSData)  -> NSDictionary  {
        var error: NSError?
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
    }
    
    static func parseDataArray (data : NSData)  -> NSArray  {
        var error: NSError?
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSArray
    }
}
