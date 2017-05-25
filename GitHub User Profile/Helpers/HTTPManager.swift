//
//  HTTPManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/19/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadCompleteWithArray =  (_ records : [[String : Any]]?, _ error : Error?) -> Void
typealias DownloadCompleteWithRecord =  (_ record : [String : Any]?, _ error : Error?) -> Void

class HTTPManager: NSObject {
    
    static var url = "https://api.github.com/"
    
    static func urlToken () -> String {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: "accessToken") {
            return "access_token=\(accessToken)"
        }
        return ""
    }
    
    static func findAll (_ className : String, options : NSDictionary!, completeWithArray : @escaping DownloadCompleteWithArray) {
        
        var optionsurl = ""
        
        if let options =  options {
            optionsurl = options.toURLString()
        }
        
        let urlstr = "\(url)\(className)?\(optionsurl)\(urlToken())"
        let request = URLRequest(url: URL(string: urlstr)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
            if error != nil {
                completeWithArray(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, let data = data  {
                if response.statusCode == 404 {
                    /*
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Not found."
                    ]
                    let notFoundError = Error(domain: "NotFound", code: 404, userInfo: userInfo)
                    completeWithArray(nil, notFoundError)
                    */
                    return
                }
                /*
                if response.statusCode == 403 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "API rate limit exceeded. (But here's the good news: Authenticated requests get a higher rate limit.)"
                    ]
                    let notFoundError = Error(domain: "OverLimit", code: 403, userInfo: userInfo)
                    completeWithArray(nil, notFoundError)
                    return
                }
                if response.statusCode == 505 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Looks like something went wrong!"
                    ]
                    let notFoundError = Error(domain: "ServerError", code: 403, userInfo: userInfo)
                    completeWithArray(nil, notFoundError)
                    return
                }
                */
                if let indata = self.parseData(data) as? [[String : Any]] {
                    completeWithArray(indata, nil)
                }
                
                
            }
            
        }
    }
    
    static func getFirst (_ className : String, options : NSDictionary!, completeWithRecord : @escaping DownloadCompleteWithRecord) {
        
        var optionsurl = ""
        let session = URLSession.shared
        
        if let options =  options {
            optionsurl = options.toURLString()
        }
    
        let request = URLRequest(url: URL(string: "\(url)\(className)?\(optionsurl)\(urlToken())")!)
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) -> Void in
            if error != nil {
                completeWithRecord(nil, error)
                return
            }
            if let response = response as? HTTPURLResponse, let data = data  {
                
                if response.statusCode == 404 {
                    /*
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Not found."
                    ]
                    let notFoundError = Error(domain: "NotFound", code: 404, userInfo: userInfo)
                    completeWithRecord(nil, notFoundError)
                    */
                    return
                }
                /*
                if response.statusCode == 403 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "API rate limit exceeded. (But here's the good news: Authenticated requests get a higher rate limit.)"
                    ]
                    let notFoundError = Error(domain: "OverLimit", code: 403, userInfo: userInfo)
                    completeWithRecord(nil, notFoundError)
                    return
                }
                if response.statusCode == 505 {
                    let userInfo = [
                        NSLocalizedDescriptionKey :  "Looks like something went wrong!"
                    ]
                    let notFoundError = Error(domain: "ServerError", code: 403, userInfo: userInfo)
                    completeWithRecord(nil, notFoundError)
                    return
                }
                 */
                if let indata = self.parseData(data) as? [String : Any] {
                    completeWithRecord(indata, nil)
                }
            }
        } )
        
        dataTask.resume()
        
    }
    
    static func parseData (_ data : Data)  -> AnyObject!  {
        //var error: Error?
        return try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
    }
    
}
