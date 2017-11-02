//
//  Constants.swift
//  GitHub
//
//  Created by Eduardo Irias on 11/2/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation

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
    case authorization = "authorizations"
    case client = "clients"
    case user = "users"
    case repos = "repos"
    case branches = "branches"
    case commits = "commits"
    case readme = "readme"
}
