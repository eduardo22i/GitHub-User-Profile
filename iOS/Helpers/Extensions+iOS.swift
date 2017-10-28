//
//  Extensions iOS.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/26/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit

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

extension UITextView {
    func removeInnerSpacing() {
        self.textContainer.lineFragmentPadding = 0
        self.textContainerInset = .zero
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
