//
//  HTTPManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/19/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

protocol Gettable {
    func createRequest(method: HTTPMethod, endpoint: Endpoint, path: String?, parameters: [String : Any]?) -> URLRequest
    func get(request: URLRequest, completionHandler: @escaping (Result<Data, APIError>) -> Void)
}

class HTTPProvider: Gettable {
    
    static var shared = HTTPProvider()
    static let url = "api.github.com"
    
    private func appendAccessToken(request: inout URLRequest) {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
    
    func createRequest(method: HTTPMethod, endpoint: Endpoint, path : String?, parameters: [String : Any]?) -> URLRequest {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = HTTPProvider.url
        urlComponents.path = "/" + endpoint.rawValue
        
        if let path = path {
            urlComponents.path += "/" + path
        }
        
        urlComponents.queryItems = parameters != nil ? [] : nil
        for (key, value) in parameters ?? [:] {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        
        if method == .put {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        appendAccessToken(request: &request)
        
        return request
    }
    
    func get(request : URLRequest, completionHandler block : @escaping (Result<Data, APIError>) -> Void) {
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    block(Result.failure(.noNetwork))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, let data = data  {
                DispatchQueue.main.async {
                    if response.statusCode == 401 {
                        let responseJson = (try? JSONDecoder().decode([String: String].self, from: data))
                        let otpRequired = responseJson?["message"] == "Must specify two-factor authentication OTP code."
                        block(Result.failure(otpRequired ? APIError.otpRequired : APIError.unauthorized))
                    } else if response.statusCode == 404 {
                        block(Result.failure(.notFound))
                    } else  if response.statusCode == 403 {
                        block(Result.failure(.limitExceeded))
                    } else if response.statusCode == 505 {
                        block(Result.failure(.serverError))
                    } else {
                        block(Result.success(data))
                    }
                }
            }
            
        }
        
        dataTask.resume()
    }
    
}
