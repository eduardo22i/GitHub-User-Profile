//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

class DataManager: NSObject {

    var clientId = ""
    var clientSecretId = ""
    
    /**
     Returns the shared defaults object.
     If the shared defaults object does not exist yet, it is created.
     */
    static let shared = DataManager()
    private override init() {}
    
    //MARK: - GET
    
    func postLogin(username: String, password: String, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let path = Endpoint.client.rawValue + "/" + clientId  + "/\(Date().timeIntervalSince1970)"
        
        var request =  HTTPManager.createRequest(endpoint: .authorization, path: path, method: .put)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try? encoder.encode(LoginRequest())
        
        request.httpBody = json
        
        HTTPManager.make(request: request) { (data, error) in
            if let error = error {
                block(nil, error)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let loginResponse = try? decoder.decode(LoginResponse.self, from: data)
                
                guard let token = loginResponse?.token else {
                    block(nil, APIError.notFound)
                    return
                }
                
                UserDefaults.standard.set(token, forKey: "accessToken")
                
                self.getCurrentUser(block: block)
                
            }
        }
    }
    
    func getCurrentUser (block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        let request =  HTTPManager.createRequest(endpoint: .user)
        HTTPManager.make(request: request) { (data, error) in
            if let data = data {
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                User.current = user
                block(User.current, nil)
            } else {
                block(nil, error)
            }
        }
    }
    
    func getUser(username: String, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        let request = HTTPManager.createRequest(endpoint: .users, path: username)
        
        HTTPManager.make(request: request) { (data, error) in
            if let error = error {
                block(nil, error)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                block(user, nil)
            }
        }
    }
    
    func getRepos(username: String, options : [String : Any]?, block : @escaping (_ repos : [Repo]?, _ error : APIError?) -> Void ) {
        
        let path = username + "/" + Endpoint.repos.rawValue
        let request = HTTPManager.createRequest(endpoint: .users, path: path, parameters: options)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let repos = try? decoder.decode([Repo].self, from: data)
                block(repos, nil)
            }
        
        }
    }
    
    func getBranches(username: String, repo : String, options : [String : Any]?, block : @escaping (_ repos : [Branch]?, _ error : APIError?) -> Void ) {
        
        let path = username + "/" + repo + "/" + Endpoint.branches.rawValue
        let request = HTTPManager.createRequest(endpoint: .repos, path: path, parameters: options)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                let branches = try? decoder.decode([Branch].self, from: data)
                block(branches, nil)
            }
        }
    }
    
    func getCommits(username: String, repo : String, branch: String, options : [String : Any]?, block : @escaping (_ repos : [Commit]?, _ error : APIError?) -> Void) {
        
        var parameters = options ?? [:]
        parameters["sha"] = branch
        
        let path = username + "/" + repo + "/" + Endpoint.commits.rawValue
        let request = HTTPManager.createRequest(endpoint: .repos, path: path, parameters: parameters)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let commits = try? decoder.decode([Commit].self, from: data)
                block(commits, nil)
            }
        }
    }
    
    func getReadme(username: String, repo : String, options : [String : Any]? = nil, block : @escaping (_ readme : File?, _ error : APIError?) -> Void) {
    
        let path = username + "/" + repo + "/" + Endpoint.readme.rawValue
    
        let request =  HTTPManager.createRequest(endpoint: .repos, path: path, parameters: options)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                let file = try? decoder.decode(File.self, from: data)
                block(file, nil)
            }
            
        }
    }
    
}
