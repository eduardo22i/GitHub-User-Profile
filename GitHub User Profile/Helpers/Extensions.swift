//
//  Extensions.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class Extensions: NSObject {
   
}

extension UIView {
    func addRoundedCorner () {
        self.layer.cornerRadius =  5
        self.layer.masksToBounds = true
    }
}