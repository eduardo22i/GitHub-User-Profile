//
//  RepoDescriptionTableViewCell.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/25/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class RepoDescriptionTableViewCell: UITableViewCell {

    @IBOutlet var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
