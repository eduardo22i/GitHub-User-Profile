//
//  User.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import Foundation

enum Type : String {
    case organization
    case user
}

class User {
    
    static var current : User?
    
    var id: Int!
    var username : String!
    var email : String?
    var name : String?
    var company : String?
    var location : String?
    var url : String?
    var avatarURL : URL?
    
    var type : Type?
    
    var imageData : Data?
    
    init() {
    }
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
    
    func downloadImage(_ block : @escaping (_ data : Data?, _ error : Error?) -> Void) {
        if imageData != nil {
            block( imageData , nil )
            return
        } else {
            if let avatarURL = self.avatarURL {
                let request = URLRequest(url: avatarURL)
                HTTPManager.make(request: request, completeBlock: { (data, error) in
                    self.imageData = data
                    DispatchQueue.main.async(execute: { () -> Void in
                        block( data, nil )
                    })
                    
                })
            }
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
        name = try? container.decode(String.self, forKey: .name)
        company = try? container.decode(String.self, forKey: .company)
        location = try? container.decode(String.self, forKey: .location)
        url = try? container.decode(String.self, forKey: .url)
        avatarURL = try? container.decode(URL.self, forKey: .avatarURL)
        if let type = try? container.decode(String.self, forKey: .type) {
            self.type = Type(rawValue: type.lowercased())
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

struct LoginRequest : Encodable {
    
    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
        case scopes
        case note
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(DataManager.shared.clientSecretId, forKey: .clientSecret)
        try container.encode(["public_repo"], forKey: .scopes)
        try container.encode(["note"], forKey: .note)
    }
    
}


struct LoginResponse : Codable {
    
    var id : Int?
    var token : String?

}
