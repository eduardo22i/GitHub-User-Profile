//
//  User.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

typealias DownloadComplete =  (_ data : Data?, _ error : Error?) -> Void

/*
 "login": "octocat",
 "id": 1,
 "avatar_url": "https://github.com/images/error/octocat_happy.gif",
 "gravatar_id": "",
 "url": "https://api.github.com/users/octocat",
 "html_url": "https://github.com/octocat",
 "followers_url": "https://api.github.com/users/octocat/followers",
 "following_url": "https://api.github.com/users/octocat/following{/other_user}",
 "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
 "organizations_url": "https://api.github.com/users/octocat/orgs",
 "repos_url": "https://api.github.com/users/octocat/repos",
 "events_url": "https://api.github.com/users/octocat/events{/privacy}",
 "received_events_url": "https://api.github.com/users/octocat/received_events",
 "type": "User",
 "site_admin": false,
 "name": "monalisa octocat",
 "company": "GitHub",
 "blog": "https://github.com/blog",
 "location": "San Francisco",
 "email": "octocat@github.com",
 "hireable": false,
 "bio": "There once was...",
 "public_repos": 2,
 "public_gists": 1,
 "followers": 20,
 "following": 0,
 "created_at": "2008-01-14T04:33:35Z",
 "updated_at": "2008-01-14T04:33:35Z"
 */

enum Type : String {
    case organization
    case user
}

class User {
    
    var id: Int! = 0
    var username : String!
    var email : String?
    var name : String?
    var company : String?
    var location : String?
    var url : String?
    var avatarURL : String?
    
    var type : Type?
    
    var imageData : Data?
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
    
    func downloadImage(_ block : @escaping DownloadComplete) {
        if imageData != nil {
            block( imageData , nil )
            return
        } else {
            DispatchQueue(label: "", attributes: []).async(execute: { () -> Void in
                let url = URL(string: self.avatarURL!)
                if let data = try? Data(contentsOf: url!) {
                    self.imageData = data
                    DispatchQueue.main.async(execute: { () -> Void in
                        block( data, nil )
                    })
                }
            })
        }
    }
   
}

extension User: Codable {
    private enum CodingKeys : String, CodingKey {
        case id = "id"
        case username = "login"
        case email = "email"
        case name = "name"
        case company = "company"
        case location = "location"
        case url = "blog"
        case avatarURL = "avatar_url"
        case type = "type"
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        email = try? container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        company = try container.decode(String.self, forKey: .company)
        location = try container.decode(String.self, forKey: .location)
        url = try container.decode(String.self, forKey: .url)
        avatarURL = try container.decode(String.self, forKey: .avatarURL)
        if let type = try? container.decode(String.self, forKey: .type) {
            self.type = Type(rawValue: type)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(company, forKey: .company)
        try container.encode(location, forKey: .location)
        try container.encode(url, forKey: .url)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(type, forKey: .type)
    }
}
