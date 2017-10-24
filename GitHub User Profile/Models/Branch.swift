//
//  Branch.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/22/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class Branch: Codable {
    
    var name : String?
    //var commit : NSDictionary!
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    private enum CodingKeys : String, CodingKey {
        case name = "name"
    }
}
