//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

class DataManager: NSObject {

    var clientId = ProcessInfo.processInfo.environment["GITHUB_CLIENT_ID"] ?? ""
    var clientSecretId = ProcessInfo.processInfo.environment["GITHUB_CLIENT_SECRET_ID"] ?? ""
    
    /**
     Returns the shared defaults object.
     If the shared defaults object does not exist yet, it is created.
     */
    static let shared = DataManager()
    private override init() {}
    
    //MARK: - GET
    
    func postLogin(username: String, password: String, otp: String? = nil, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let path = Endpoint.client.rawValue + "/" + clientId  + "/\(Date().timeIntervalSince1970)"
        
        var request =  HTTPManager.createRequest(endpoint: .authorization, path: path, method: .put)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        if let otp = otp {
            request.addValue(otp, forHTTPHeaderField: "X-GitHub-OTP")
        }
        
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
    
    func getCurrentUser (block : @escaping (_ user : User.Individual?, _ error : APIError?) -> Void) {
        let request =  HTTPManager.createRequest(endpoint: .user)
        HTTPManager.make(request: request) { (data, error) in
            if let data = data {
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.Individual.self, from: data)
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
                if let type = user?.type {
                    let decoder = JSONDecoder()
                    switch type {
                    case .user:
                        let individual = try? decoder.decode(User.Individual.self, from: data)
                        block(individual, nil)
                    case .organization:
                        let organization = try? decoder.decode(User.Organization.self, from: data)
                        block(organization, nil)
                    }
                    return
                }
                block(user, nil)
            }
        }
    }
    
    func getOrganizations(user: User, options : [String : Any]? = nil, block : @escaping (_ repos : [User.Organization]?, _ error : APIError?) -> Void ) {
        
        let path = user.username + "/" + Endpoint.organizations.rawValue
        let request =  HTTPManager.createRequest(endpoint: .users, path: path)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                
                let dispatchGroup = DispatchGroup()
                
                var organizations = [User.Organization]()
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let organizationsRaw = try? decoder.decode([User.Organization].self, from: data)
                
                organizationsRaw?.forEach({ (organization) in
                    
                    dispatchGroup.enter()
                    
                    if let url = organization.dataURL {
                        
                        var request = URLRequest(url: url)
                        request.appendAccessToken()
                        
                        HTTPManager.make(request: request, completeBlock: { (data, error) in
                            
                            guard let data = data else {
                                dispatchGroup.leave()
                                return
                            }
                            
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            
                            if let organization = try? decoder.decode(User.Organization.self, from: data) {
                                organizations.append(organization)
                            }
                            
                            dispatchGroup.leave()
                            
                        })
                    }
                    
                })
                
                dispatchGroup.notify(queue: .main) {
                    block(organizations, nil)
                }
                
            }
            
        }
    }
    
    
    func getRepos(user: User, options : [String : Any]? = nil, block : @escaping (_ repos : [Repo]?, _ error : APIError?) -> Void ) {
        
        let path = user.username + "/" + Endpoint.repos.rawValue
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
    
    func getCommits(repo : Repo, branch: String, options : [String : Any]?, block : @escaping (_ repos : [Commit]?, _ error : APIError?) -> Void) {
        
        var parameters = options ?? [:]
        parameters["sha"] = branch
        
        let path = repo.owner.username + "/" + repo.name + "/" + Endpoint.commits.rawValue
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
    
    func getReadme(repo : Repo, options : [String : Any]? = nil, block : @escaping (_ readme : File?, _ error : APIError?) -> Void) {
    
        let path = repo.owner.username + "/" + repo.name + "/" + Endpoint.readme.rawValue
    
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
    
    func getEvents(user: User, options : [String : Any]? = nil, block : @escaping (_ events : [Event]?, _ error : APIError?) -> Void) {
        
        let path = user.username + "/" + Endpoint.events.rawValue
        
        let request =  HTTPManager.createRequest(endpoint: .users, path: path, parameters: options)
        
        HTTPManager.make(request: request) { (data, error) in
            
            if let error = error {
                block(nil, error)
                return
            }
            
            if let data = data {
                
                let myGroup = DispatchGroup()

                let decoder = JSONDecoder()
                
                let events = try? decoder.decode([Event].self, from: data)
                
                events?.forEach({ (event) in
                    
                    myGroup.enter()
                    
                    if let repoUrl = event.eventRepo?.url {
                        
                        var request = URLRequest(url: repoUrl)
                        request.appendAccessToken()
                        
                        HTTPManager.make(request: request, completeBlock: { (data, error) in
                            
                            guard let data = data else {
                                myGroup.leave()
                                return
                            }
                            
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            
                            event.repo = try? decoder.decode(Repo.self, from: data)
                            
                            myGroup.leave()
                            
                        })
                    }
                    
                })
                
                myGroup.notify(queue: .main) {
                    block(events, nil)
                }
                
            }
            
        }
    }
}
