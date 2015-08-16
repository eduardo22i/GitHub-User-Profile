//
//  User.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class User: NSObject {
    var id : String!
    var username : String!
    var email : String!
    var url : String!
    var avatar_url : String!
    var repos_url : String!
    
    var followers  = 0
    var following  = 0
}
