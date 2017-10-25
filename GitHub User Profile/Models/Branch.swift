//
//  Branch.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/22/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class Branch {
    
    var name : String?
    var commits = [Commit]()
    
    init(name : String) {
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
}

extension Branch: Codable {
    private enum CodingKeys : String, CodingKey {
        case name = "name"
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
}
