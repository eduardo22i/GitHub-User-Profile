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

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSizeMake(self.size.width + insets.left + insets.right,
                self.size.height + insets.top + insets.bottom), false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.drawAtPoint(origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
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