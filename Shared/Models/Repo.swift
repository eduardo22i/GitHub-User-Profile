//
//  Repo.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

class Repo {
    
    var id: Int!
    var name: String!
    var fullName: String!
    var description: String?
    var language: String?

    var defaultBranch : String?
    
    var url : URL!
    
    var watchersCount = 0
    var stargazersCount = 0
    
    var isForked = false
    var isPrivate = false
    
    var branches = [Branch]()
    
    var pushedAt : Date?
    var updatedAt : Date!
    var createdAt : Date!
    
    var readme : Markdown!
    
    var owner : User!
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
}

extension Repo: Codable {
    private enum CodingKeys : String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
        case language
        case defaultBranch = "default_branch"
        case url = "html_url"
        case watchersCount = "watchers"
        case stargazersCount = "stargazers_count"
        case isForked = "fork"
        case isPrivate = "private"
        case pushedAt = "pushed_at"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        description = try? container.decode(String.self, forKey: .description)
        language = try? container.decode(String.self, forKey: .language)
        defaultBranch = try? container.decode(String.self, forKey: .defaultBranch)
        url = try? container.decode(URL.self, forKey: .url)
        watchersCount = (try? container.decode(Int.self, forKey: .watchersCount)) ?? 0
        stargazersCount = (try? container.decode(Int.self, forKey: .stargazersCount)) ?? 0
        isForked = (try? container.decode(Bool.self, forKey: .isForked)) ?? false
        isPrivate = (try? container.decode(Bool.self, forKey: .isPrivate)) ?? false
        
        pushedAt = try? container.decode(Date.self, forKey: .pushedAt)
        updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        createdAt = try? container.decode(Date.self, forKey: .createdAt)
        
        if let defaultBranch = defaultBranch {
            branches.append(Branch(name: defaultBranch))
        }
        
        owner = try? container.decode(User.self, forKey: .owner)
    }
    
    func encode(to encoder: Encoder) throws {
    }
}
