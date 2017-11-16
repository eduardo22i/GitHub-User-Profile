//
//  HTTPManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/19/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func appendAccessToken() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            self.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
}

class HTTPManager: NSObject {
    
    static let url = "api.github.com"
    
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
        
        if method == .put {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        request.appendAccessToken()
        
        return request
    }
    
    static func make (request : URLRequest, completeBlock block : @escaping (_ records: Data?, _ error : APIError?) -> Void) {
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    block(nil, .noNetwork)
                }
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
    
}
