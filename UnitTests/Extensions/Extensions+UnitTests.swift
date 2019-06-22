//
//  Extensions.swift
//  GitHub UnitTests
//
//  Created by Eduardo Irias on 11/2/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func appendAccessToken() {
        
    }
    
    func mockDataTask() -> Data? {
        /*
        guard let bundle : Bundle = Bundle(identifier: "com.estamp.UnitTests") else {
            return
        }
        
        guard let fileUrl = bundle.url(forResource: "MockRequestMap", withExtension: "plist"),
            let plistData = try? Data(contentsOf: fileUrl) else {
                return nil
        }
        
        guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: String] else {
            return nil
        }
        
        var resourceOpt : String? = result?[self.url!.absoluteString]
        
        if resourceOpt == nil {
            for (key, value) in result ?? [:] {
                if self.url!.absoluteString.contains(key.replacingOccurrences(of: "{date}", with: "")) {
                    resourceOpt = value
                    break
                }
            }
        }
        
        guard let resource = resourceOpt else {
            return nil
        }
        
        
        guard let pathURL =  bundle.url(forResource: resource, withExtension: "json") else {
        guard let result = ((try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: String]) as [String : String]??) else {
            return nil
        }
        
        
        guard let data = try? Data(contentsOf: pathURL, options: Data.ReadingOptions.mappedIfSafe) else {
            return nil
        }
        
        return data
 */
        return nil
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
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    static func make (request : URLRequest, completeBlock block : @escaping (_ records: Data?, _ error : APIError?) -> Void) {
        
        block(request.mockDataTask(), nil)
    }
    
}
