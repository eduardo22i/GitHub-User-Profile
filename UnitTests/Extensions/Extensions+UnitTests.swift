//
//  Extensions.swift
//  GitHub UnitTests
//
//  Created by Eduardo Irias on 11/2/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation
@testable import iOS

class MockProvider: Gettable {
    
    func createRequest(method: HTTPMethod, endpoint: Endpoint, path: String?, parameters: [String : Any]?) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "local"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/" + endpoint.rawValue
        
        if let path = path {
            urlComponents.path += "/" + path
        }
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue

        return request
    }
    
    func get(request: URLRequest, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        
        let bundle: Bundle = Bundle(for: type(of: self))
        
        guard let fileUrl = bundle.url(forResource: "MockRequestMap", withExtension: "plist"),
            let plistData = try? Data(contentsOf: fileUrl) else {
                completionHandler(Result.failure(.notFound))
                return
        }
        
        guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [AnyHashable: Any] else {
            completionHandler(Result.failure(.notFound))
            return
        }
        
        let endpoint = request.url?.pathComponents[1] ?? ""
        let mockRequestMap = result[endpoint] as? [AnyHashable: Any]
        
        guard let response = mockRequestMap?[request.httpMethod ?? "GET"] as? [AnyHashable: Any],
        let statusCode = response["code"] as? Int,
        let filePath = response["data"] as? String
        else {
            completionHandler(Result.failure(.notFound))
            return
        }
 
        guard let pathURL =  bundle.url(forResource: filePath, withExtension: "json") else {
            completionHandler(Result.failure(.notFound))
            return
        }
        
        guard let data = try? Data(contentsOf: pathURL, options: Data.ReadingOptions.mappedIfSafe) else {
            completionHandler(Result.failure(.notFound))
            return
        }
        
        if statusCode == 401 {
            let responseJson = (try? JSONDecoder().decode([String: String].self, from: data))
            let otpRequired = responseJson?["message"] == "Must specify two-factor authentication OTP code."
            completionHandler(Result.failure(otpRequired ? APIError.otpRequired : APIError.unauthorized))
        } else if statusCode == 404 {
            completionHandler(Result.failure(.notFound))
        } else  if statusCode == 403 {
            completionHandler(Result.failure(.limitExceeded))
        } else if statusCode == 505 {
            completionHandler(Result.failure(.serverError))
        } else {
            completionHandler(Result.success(data))
        }
        
    }
}
