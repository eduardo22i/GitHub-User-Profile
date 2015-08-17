//
//  Extensions.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

extension UIView {
    func addRoundedCorner () {
        self.layer.cornerRadius =  5
        self.layer.masksToBounds = true
    }
}

extension String {
    var removeComma:String {
        return "".join(componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: ",")))
    }
    var webUrl:NSURL {
        return NSURL(string: stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    }
}