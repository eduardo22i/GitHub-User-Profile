//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadCompleteUser     = (_ user : User?, _ error : Error?) -> Void
typealias DownloadCompleteRecord   = (_ record : AnyObject?, _ error : Error?) -> Void
typealias DownloadCompleteRecords  = (_ records : [AnyObject]?, _ error : Error?) -> Void

class DataManager: NSObject {
    
    static var RepoClass = "repos"
    static var BranchClass = "branches"
    static var CommitsClass = "commits"
    
    
    //MARK: - GET
    
    static func getUser(_ username: String, block : @escaping (_ user : User?, _ error : APIError?) -> Void) {
        
        let request = HTTPManager.createRequest(endpoint: .user, path: username)
        
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
    
    static func getRepos(_ username: String, options : [String : Any]?, block : @escaping (_ repos : [Repo]?, _ error : APIError?) -> Void ) {
        
        let path = username + "/" + Endpoint.repos.rawValue
        let request = HTTPManager.createRequest(endpoint: .user, path: path, parameters: options)
        
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
    
    static func getBranches(_ username: String, repo : String, options : [String : Any]?, block : @escaping (_ repos : [Branch]?, _ error : APIError?) -> Void ) {
        
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
    
    static func getCommits(_ username: String, repo : String, branch: String, options : [String : Any]?, block : @escaping (_ repos : [Commit]?, _ error : APIError?) -> Void) {
        
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
    
    //MARK: - Helpers
    
    static func prepareRequestParameters (_ options : NSDictionary!) -> NSDictionary {
        let optionsSend = NSMutableDictionary()
        if let options = options as? [String : AnyObject] {
            optionsSend.setValuesForKeys(options)
        }
        optionsSend.setValue(100, forKey: "per_page")
        return optionsSend
    }
    
    
    @discardableResult static func setKeysAndValues (_ object : AnyObject, dictionary : [String : Any])  -> AnyObject  {
        
        for (key, value) in dictionary {
            if !(key == "description") {
                if let keyValue = value as? String {
                    if (object.responds(to: NSSelectorFromString(key))) {
                        object.setValue(keyValue, forKey: key)
                    }
                }
                if let keyValue = value as? Int {
                    if (object.responds(to: NSSelectorFromString(key))) {
                        object.setValue(keyValue, forKey: key)
                    }
                }
                if let keyValue = value as? NSDictionary {
                    if (object.responds(to: NSSelectorFromString(key))) {
                        object.setValue(keyValue, forKey: key)
                    }
                }
            } else {
                let key = "alternateDescription"
                if let value = value as? String {
                    if (object.responds(to: NSSelectorFromString(key))) {
                        object.setValue(value, forKey: key)
                    }
                }
            }
            
        }
        
        return object
        
    }
    
}
