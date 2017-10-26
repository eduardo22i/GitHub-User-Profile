//
//  Extensions.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

extension String {
    var removeComma:String {
        return components(separatedBy: CharacterSet(charactersIn: ",")).joined(separator: "")
    }
    var webUrl:URL {
        
        return URL(string: addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)! )!
    }
}
