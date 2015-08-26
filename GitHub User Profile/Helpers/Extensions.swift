//
//  Extensions.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class Extension : NSObject {
    static let Edge =  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
}

extension UIView {
    func addRoundedCorner () {
        self.layer.cornerRadius =  5
        self.layer.masksToBounds = true
    }
}

extension UIImageView {
    func addImageInsets(insets: UIEdgeInsets) {
        if let image = self.image {
            UIGraphicsBeginImageContextWithOptions(
                CGSizeMake(image.size.width + insets.left + insets.right,
                    image.size.height + insets.top + insets.bottom), false, image.scale)
            let context = UIGraphicsGetCurrentContext()
            let origin = CGPoint(x: insets.left, y: insets.top)
            image.drawAtPoint(origin)
            let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.image = imageWithInsets
        }
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