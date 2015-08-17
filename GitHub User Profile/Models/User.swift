//
//  User.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadComplete =  (data : NSData?, error : NSError?) -> Void

class User: NSObject {
    
    var id = 0
    
    var location : String!
    var url : String!
    var following_url : String!
    var events_url : String!
    var received_events_url : String!
    var updated_at : String!
    var avatar_url : String!
    var name : String!
    var type : String!
    var subscriptions_url : String!
    var gists_url : String!
    var starred_url : String!
    var organizations_url : String!
    var repos_url : String!
    var email : String!
    var login : String!
    var blog : String!
    var created_at : String!
    var company : String!
    var gravatar_id : String!
    var followers_url : String!
    var html_url : String!
    
    var hireable = 0
    var public_gists = 0
    var site_admin = 0
    var public_repos = 0
    var followers = 0
    var following = 0
    
    var imageData : NSData!
    
    override init () {
        super.init()
    }
    
    func downloadImage(block : DownloadComplete) {
        if imageData != nil {
            block( data: imageData , error :  nil )
            return
        } else {
            dispatch_async(dispatch_queue_create("", nil), { () -> Void in
                let url = NSURL(string: self.avatar_url)
                if let data = NSData(contentsOfURL: url!) {
                    self.imageData = data
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        block( data: data, error :  nil )
                    })
                }
            })
        }
    }
   
}
