//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

class DataManager {

    var clientId = ProcessInfo.processInfo.environment["GITHUB_CLIENT_ID"] ?? ""
    var clientSecretId = ProcessInfo.processInfo.environment["GITHUB_CLIENT_SECRET_ID"] ?? ""
    
    var service : Gettable
    
    /**
     Returns the shared defaults object.
     If the shared defaults object does not exist yet, it is created.
     */
    static let shared = DataManager()
    private init() {
        service = HTTPProvider.shared
    }
    
    //MARK: - GET
    
    func postLogin(username: String, password: String, otp: String? = nil, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let loginData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let path = Endpoint.client.rawValue + "/" + clientId  + "/\(Date().timeIntervalSince1970)"
        
        var request =  service.createRequest(method: .put, endpoint: .authorization, path: path, parameters: nil)
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        if let otp = otp {
            request.addValue(otp, forHTTPHeaderField: "X-GitHub-OTP")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        request.httpBody = try? encoder.encode(LoginRequest())
        
        service.get(request: request) { result in
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let loginResponse = try? decoder.decode(LoginResponse.self, from: data)
                
                guard let token = loginResponse?.token else {
                    block(nil, APIError.notFound)
                    return
                }
                
                UserDefaults.standard.set(token, forKey: "accessToken")
                
                self.getCurrentUser(block: block)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getCurrentUser (block : @escaping (_ user : User.Individual?, _ error : APIError?) -> Void) {
        let request =  service.createRequest(method: .get, endpoint: .user, path: nil, parameters: nil)
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.Individual.self, from: data)
                User.current = user
                block(User.current, nil)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getUser(username: String, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        let request = service.createRequest(method: .get, endpoint: .users, path: username, parameters: nil)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
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
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getOrganizations(user: User, options : [String : Any]? = nil, block : @escaping (_ repos : [User.Organization]?, _ error : APIError?) -> Void ) {
        
        let path = user.username + "/" + Endpoint.organizations.rawValue
        let request =  service.createRequest(method: .get, endpoint: .users, path: path, parameters: nil)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
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
                        
                        // TODO: Replace this
                        self.service.get(request: request, completionHandler: { result in
                            switch result {
                            case .success(let data):
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .iso8601
                                
                                if let organization = try? decoder.decode(User.Organization.self, from: data) {
                                    organizations.append(organization)
                                }
                            case .failure(_):
                                break
                            }
                            
                            dispatchGroup.leave()
                            
                        })
                    }
                    
                })
                
                dispatchGroup.notify(queue: .main) {
                    block(organizations, nil)
                }
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    
    func getRepos(user: User, options : [String : Any]? = nil, block : @escaping (_ repos : [Repo]?, _ error : APIError?) -> Void ) {
        
        let path = user.username + "/" + Endpoint.repos.rawValue
        let request = service.createRequest(method: .get, endpoint: .users, path: path, parameters: options)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let repos = try? decoder.decode([Repo].self, from: data)
                
                block(repos, nil)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getBranches(username: String, repo : String, options : [String : Any]?, block : @escaping (_ repos : [Branch]?, _ error : APIError?) -> Void ) {
        
        let path = username + "/" + repo + "/" + Endpoint.branches.rawValue
        let request = service.createRequest(method: .get, endpoint: .repos, path: path, parameters: options)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                let branches = try? decoder.decode([Branch].self, from: data)
                block(branches, nil)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getCommits(repo : Repo, branch: String, options : [String : Any]?, block : @escaping (_ repos : [Commit]?, _ error : APIError?) -> Void) {
        
        var parameters = options ?? [:]
        parameters["sha"] = branch
        
        let path = repo.owner.username + "/" + repo.name + "/" + Endpoint.commits.rawValue
        let request = service.createRequest(method: .get, endpoint: .repos, path: path, parameters: parameters)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let commits = try? decoder.decode([Commit].self, from: data)
                block(commits, nil)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getReadme(repo : Repo, options : [String : Any]? = nil, block : @escaping (_ readme : File?, _ error : APIError?) -> Void) {
    
        let path = repo.owner.username + "/" + repo.name + "/" + Endpoint.readme.rawValue
    
        let request =  service.createRequest(method: .get, endpoint: .repos, path: path, parameters: options)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                let file = try? decoder.decode(File.self, from: data)
                block(file, nil)
            case .failure(let error):
                block(nil, error)
            }
        }
    }
    
    func getEvents(user: User, options : [String : Any]? = nil, block : @escaping (_ events : [Event]?, _ error : APIError?) -> Void) {
        
        let path = user.username + "/" + Endpoint.events.rawValue
        
        let request =  service.createRequest(method: .get, endpoint: .users, path: path, parameters: options)
        
        service.get(request: request) { result in
            switch result {
            case .success(let data):
                let myGroup = DispatchGroup()
                
                let decoder = JSONDecoder()
                
                let events = try? decoder.decode([Event].self, from: data)
                
                events?.forEach({ (event) in
                    
                    myGroup.enter()
                    
                    if let repoUrl = event.eventRepo?.url {
                        
                        var request = URLRequest(url: repoUrl)
                        request.appendAccessToken()
                        
                        // TODO: Replace this
                        self.service.get(request: request, completionHandler: { result in
                            switch result {
                            case .success(let data):
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .iso8601
                                
                                event.repo = try? decoder.decode(Repo.self, from: data)
                            case .failure(_):
                                break
                            }
                            myGroup.leave()
                        })
                    }
                    
                })
                
                myGroup.notify(queue: .main) {
                    block(events, nil)
                }
            case .failure(let error):
                block(nil, error)
            }
        }
    }
}
