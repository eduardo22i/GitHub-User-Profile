//
//  HTTPManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/19/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

enum APIError: Error {
    case notFound
    case limitExceeded
    case serverError
    case noNetwork
    
    var description: String {
        switch self {
        case .notFound:
            return "Not found."
        case .limitExceeded:
            return "API rate limit exceeded. (But here's the good news: Authenticated requests get a higher rate limit.)"
        case .serverError:
            return "Looks like something went wrong!"
        case .noNetwork:
            return "Looks like we are unable to communicate with the servers"
        }
    }
    
    var code : Int {
        switch self {
        case .notFound:
            return 404
        case .limitExceeded:
            return 403
        case .serverError:
            return 505
        case .noNetwork:
            return 0
        }
    }
}

enum HTTPMethod : String {
    case get
    case post
    case put
    case delete
}


enum Endpoint : String {
    case user = "users"
    case repos = "repos"
}

typealias DownloadCompleteWithArray =  (_ records : [[String : Any]]?, _ error : Error?) -> Void
typealias DownloadCompleteWithRecord =  (_ record : [String : Any]?, _ error : Error?) -> Void

class HTTPManager: NSObject {
    
    static let url = "api.github.com"
    
    static func urlToken () -> String {
        let defaults = UserDefaults.standard
        if let accessToken = defaults.string(forKey: "accessToken") {
            return "access_token=\(accessToken)"
        }
        return ""
    }
    
    static func createRequest(endpoint : Endpoint, path : String? = nil, parameters : [String : Any]? = nil, method : HTTPMethod = .get) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = HTTPManager.url
        urlComponents.path = "/" + endpoint.rawValue
        
        if let path = path {
            urlComponents.path += "/" + path
        }
        
        if let parameters = parameters {
            urlComponents.queryItems = []
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    static func make (request : URLRequest, completeBlock block : @escaping (_ records: Data?, _ error : APIError?) -> Void) {
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                block(nil, .noNetwork)
                return
            }
            
            if let response = response as? HTTPURLResponse, let data = data  {
                
                DispatchQueue.main.async {
                    
                    if response.statusCode == 404 {
                        block(nil, APIError.notFound)
                        return
                    } else  if response.statusCode == 403 {
                        block(nil, APIError.limitExceeded)
                        return
                    } else if response.statusCode == 505 {
                        block(nil, APIError.serverError)
                        return
                    }
                    
                    block(data, nil)
                }
            }
            
        }
        
        dataTask.resume()
    }
    
    static func findAll (_ className : String, options : NSDictionary!, completeWithArray : @escaping DownloadCompleteWithArray) {
        
        var optionsurl = ""
        
        if let options =  options {
            //optionsurl = options.toURLString()
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
            //optionsurl = options.toURLString()
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
