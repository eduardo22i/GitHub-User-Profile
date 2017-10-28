//
//  File.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/28/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import Foundation

class File {
    var name : String?
    var path : String?
    var content : Data?
    var sha : String?
    
    required init(from decoder: Decoder) throws {
        try self.decode(decoder: decoder)
    }
}

extension File: Decodable {
    
    private enum CodingKeys : String, CodingKey {
        case name = "name"
        case path = "path"
        case content = "content"
        case sha = "sha"
    }
    
    func decode(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try? container.decode(String.self, forKey: .name)
        path = try? container.decode(String.self, forKey: .path)
        sha = try? container.decode(String.self, forKey: .sha)
        
        if let rawContent = try? container.decode(String.self, forKey: .content) {
            self.content = Data(base64Encoded: rawContent, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        }
        
    }
    
}
