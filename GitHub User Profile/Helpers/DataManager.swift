//
//  DataManager.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadCompleteUser     = (user : User?, error : NSError?) -> Void
typealias DownloadCompleteRecord   = (record : AnyObject?, error : NSError?) -> Void
typealias DownloadCompleteRecords  = (records : [AnyObject]?, error : NSError?) -> Void

class DataManager: NSObject {
    
    static var UserClass = "users"
    static var RepoClass = "repos"
    static var BranchClass = "branches"
    static var CommitsClass = "commits"
    
    
    //MARK: - GET
    
    static func getUser(username: String, block : DownloadCompleteUser) {
        HTTPManager.getFirst("\(UserClass)/\(username)", options : nil, completeWithRecord: { (record, error : NSError?) -> Void in
            if let error = error {
                block(user : nil, error: error)
                return
            }
            let user = User()
            self.setKeysAndValues(user, dictionary: record as! NSDictionary)
            block(user : user, error: nil)
        })
    }
    
    static func getRepos(username: String, options : NSDictionary!, block : DownloadCompleteRecords ) {
        
        HTTPManager.findAll("\(UserClass)/\(username)/\(RepoClass)", options : prepareRequestParameters(options), completeWithArray: { (records, error) -> Void in
            
            if let error = error {
                block(records : nil, error: error)
                return
            }
            
            var repos = [Repo()]
            for repoDic in records {
                if let repo = self.setKeysAndValues(Repo(), dictionary: repoDic as! NSDictionary) as? Repo {
                    repos.append(repo)
                }
            }
            repos.removeAtIndex(0)
            block(records : repos, error: nil)
        })
    }
    
    static func getBranches(username: String, repo : String, options : NSDictionary!, block : DownloadCompleteRecords) {
        HTTPManager.findAll("\(RepoClass)/\(username)/\(repo)/\(BranchClass)", options : prepareRequestParameters(options), completeWithArray: { (records, error : NSError?) -> Void in
            
            if let error = error {
                block(records : nil, error: error)
                return
            }
            
            var branches = [Branch()]
            for repoDic in records {
                if let branch = self.setKeysAndValues(Branch(), dictionary: repoDic as! NSDictionary) as? Branch {
                    branches.append(branch)
                }
            }
            branches.removeAtIndex(0)
            block(records: branches, error: nil)
        })
    }
    
    static func getCommits(username: String, repo : String, options : NSDictionary!, block : DownloadCompleteRecords) {
        HTTPManager.findAll("\(RepoClass)/\(username)/\(repo)/\(CommitsClass)", options : prepareRequestParameters(options), completeWithArray: { (records, error : NSError?) -> Void in
            
            if let error = error {
                block(records : nil, error: error)
                return
            }
            
            var commits = [Commit()]
            for repoDic in records {
                if let commit = self.setKeysAndValues(Commit(), dictionary: repoDic as! NSDictionary) as? Commit {
                    commits.append(commit)
                }
            }
            commits.removeAtIndex(0)
            block(records: commits, error: nil)
        })
    }
    
    //MARK: - Helpers
    
    static func prepareRequestParameters (options : NSDictionary!) -> NSDictionary {
        let optionsSend = NSMutableDictionary()
        if let options = options as? [String : AnyObject] {
            optionsSend.setValuesForKeysWithDictionary(options)
        }
        optionsSend.setValue(100, forKey: "per_page")
        return optionsSend
    }
    
    
    static func setKeysAndValues (object : AnyObject, dictionary : NSDictionary)  -> AnyObject  {
        
        for (key, value) in dictionary {
            if !(key as! String == "description") {
                if let keyName = key  as? String {
                    if let keyValue = value as? String {
                        if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                            object.setValue(keyValue, forKey: keyName)
                        }
                    }
                    if let keyValue = value as? Int {
                        if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                            object.setValue(keyValue, forKey: keyName)
                        }
                    }
                    if let keyValue = value as? NSDictionary {
                        if (object.respondsToSelector(NSSelectorFromString(keyName))) {
                            object.setValue(keyValue, forKey: keyName)
                        }
                    }
                }
            } else {
                let key = "alternateDescription"
                if let value = value as? String {
                    if (object.respondsToSelector(NSSelectorFromString(key))) {
                        object.setValue(value, forKey: key)
                    }
                }
            }
            
        }
        
        return object
        
    }
    
}
