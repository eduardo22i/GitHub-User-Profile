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

extension NSMutableAttributedString {
    
    func replace(tag: String, withAttributes attributes: [NSAttributedStringKey: Any]) -> NSMutableAttributedString {
        let closeTag = "\n"
        
        let resultingText = self
        
        
        while true {
            let plainString = resultingText.string as NSString
            let openTagRange = plainString.range(of: tag)
            if openTagRange.length == 0 {
                break
            }
            
            let affectedLocation = openTagRange.location + openTagRange.length
            
            let searchRange = NSRange(location: affectedLocation, length: plainString.length - affectedLocation)
            
            let closeTagRange = plainString.range(of: closeTag, options: NSString.CompareOptions.init(rawValue: 0), range: searchRange)
            
            resultingText.setAttributes(attributes, range: NSRange(location: affectedLocation, length: closeTagRange.location - affectedLocation))
            
            resultingText.deleteCharacters(in: openTagRange)
        }
        
        return resultingText
    }
}
