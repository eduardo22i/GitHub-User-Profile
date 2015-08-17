//
//  UserInfoTableViewCell.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userCompanyLabel: UILabel!
    @IBOutlet var userLocationLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var userURLLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
