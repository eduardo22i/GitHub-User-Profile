//
//  HTTPManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/19/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadCompleteWithArray =  (records : [AnyObject]!, error : NSError?) -> Void
typealias DownloadCompleteWithRecord =  (record : AnyObject!, error : NSError?) -> Void

class HTTPManager: NSObject {
    
    static var url = "https://api.github.com/"
    
    static func urlToken () -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let accessToken = defaults.stringForKey("accessToken") {
            return "access_token=\(accessToken)"
        }
        return ""
    }
    
    static func findAll (className : String, options : NSDictionary!, completeWithArray : DownloadCompleteWithArray) {
        
        var optionsurl = ""
        
        if let options =  options {
            optionsurl = options.toURLString()
        }
        
        let urlstr = "\(url)\(className)?\(optionsurl)\(urlToken())"
        let request = NSURLRequest(URL: NSURL(string: urlstr)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if error != nil {
                completeWithArray(records: nil, error: error)
                return
            }
            if let response = response as? NSHTTPURLResponse, let data = data  {
                if response.statusCode == 404 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Not found."
                    ]
                    let notFoundError = NSError(domain: "NotFound", code: 404, userInfo: userInfo)
                    completeWithArray(records: nil, error: notFoundError)
                    return
                }
                if response.statusCode == 403 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "API rate limit exceeded. (But here's the good news: Authenticated requests get a higher rate limit.)"
                    ]
                    let notFoundError = NSError(domain: "OverLimit", code: 403, userInfo: userInfo)
                    completeWithArray(records: nil, error: notFoundError)
                    return
                }
                if response.statusCode == 505 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Looks like something went wrong!"
                    ]
                    let notFoundError = NSError(domain: "ServerError", code: 403, userInfo: userInfo)
                    completeWithArray(records: nil, error: notFoundError)
                    return
                }
                if let indata = self.parseData(data) as? [AnyObject] {
                    completeWithArray(records: indata, error: nil)
                }
                
                
            }
            
        }
    }
    
    static func getFirst (className : String, options : NSDictionary!, completeWithRecord : DownloadCompleteWithRecord) {
        
        var optionsurl = ""
        
        if let options =  options {
            optionsurl = options.toURLString()
        }
    
        let request = NSURLRequest(URL: NSURL(string: "\(url)\(className)?\(optionsurl)\(urlToken())")!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if error != nil {
                completeWithRecord(record: nil, error: error)
                return
            }
            if let response = response as? NSHTTPURLResponse, let data = data  {
                if response.statusCode == 404 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Not found."
                    ]
                    let notFoundError = NSError(domain: "NotFound", code: 404, userInfo: userInfo)
                    completeWithRecord(record: nil, error: notFoundError)
                    return
                }
                if response.statusCode == 403 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "API rate limit exceeded. (But here's the good news: Authenticated requests get a higher rate limit.)"
                    ]
                    let notFoundError = NSError(domain: "OverLimit", code: 403, userInfo: userInfo)
                    completeWithRecord(record: nil, error: notFoundError)
                    return
                }
                if response.statusCode == 505 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Looks like something went wrong!"
                    ]
                    let notFoundError = NSError(domain: "ServerError", code: 403, userInfo: userInfo)
                    completeWithRecord(record: nil, error: notFoundError)
                    return
                }
                if let indata = self.parseData(data) as? NSDictionary {
                    completeWithRecord(record: indata, error: nil)
                }
            }
        }
    }
    
    static func parseData (data : NSData)  -> AnyObject!  {
        var error: NSError?
        return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)!
    }
    
}
