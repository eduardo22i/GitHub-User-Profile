//
//  RepoBranchesTableViewCell.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/25/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class RepoBranchesTableViewCell: UITableViewCell {

    @IBOutlet var branchLabel: UILabel!
    @IBOutlet var branchIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
