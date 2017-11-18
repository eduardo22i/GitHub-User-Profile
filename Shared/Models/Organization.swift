//
//  Organization.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 11/18/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation

extension User {
    class Organization: User {
        
        var collaborators : Int?
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            
            let container = try decoder.container(keyedBy: User.CodingKeys.self)
            collaborators = try? container.decode(Int.self, forKey: .collaborators)
            type = .organization
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            collaborators = aDecoder.decodeObject(forKey: User.CodingKeys.collaborators.rawValue) as? Int
        }
        
        override func encode(with aCoder: NSCoder) {
            super.encode(with: aCoder)
            aCoder.encode(collaborators, forKey: User.CodingKeys.collaborators.rawValue)
        }
        
    }
}
