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
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}

extension UIImageView {
    func addImageInsets(_ insets: UIEdgeInsets) {
        if let image = self.image {
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: image.size.width + insets.left + insets.right,
                    height: image.size.height + insets.top + insets.bottom), false, image.scale)
            //let context = UIGraphicsGetCurrentContext()
            let origin = CGPoint(x: insets.left, y: insets.top)
            image.draw(at: origin)
            let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.image = imageWithInsets
        }
    }
}

extension UIButton {
    func setTitleWithoutAnimation(_ title : String?, for controlState: UIControlState) {
        UIView.setAnimationsEnabled(false)
        self.setTitle(title, for: controlState)
        UIView.setAnimationsEnabled(true)
    }

}
extension String {
    var removeComma:String {
        return components(separatedBy: CharacterSet(charactersIn: ",")).joined(separator: "")
    }
    var webUrl:URL {
        
        return URL(string: addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)! )!
    }
}

extension NSDictionary {
    func toURLString () -> String {
        var optionsstr = ""
        let options = self
        for option in options {
            if let key = option.key as? String, let value: AnyObject = option.value as AnyObject! {
                optionsstr = "\(optionsstr)\(key)=\(value)&"
            }
            
        }
        
        return optionsstr
    }
}
