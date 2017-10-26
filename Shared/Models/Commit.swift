//
//  Commit.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/26/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

class Commit {
    
    var sha : String?
    var message : String?
    var date : Date?
    var user : User?
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
}

extension Commit: Codable {
    private enum CodingKeys : String, CodingKey {
        case commit = "commit"
        case message = "message"
        case author = "author"
        case date = "date"
        case login = "login"
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let commitContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .commit)
        
        message = try commitContainer.decode(String.self, forKey: .message)
        
        let commitAuthorContainer = try commitContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
        
        date = try commitAuthorContainer.decode(Date.self, forKey: .date)

        let authorContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
        
        if let login = try? authorContainer.decode(String.self, forKey: .login) {
            
            DataManager.getUser(login, block: { (user, error) in
                if let user = user {
                    self.user = user
                }
            })
        }

    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
