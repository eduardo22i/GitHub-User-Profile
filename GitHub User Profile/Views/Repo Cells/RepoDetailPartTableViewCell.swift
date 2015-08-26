//
//  RepoBranchesTableViewCell.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/25/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

protocol RepoDetailPartDelegate {
    func detailButtonClicked(segueIdentifier : String)
}

class RepoDetailPartTableViewCell: UITableViewCell {

    var delegate : RepoDetailPartDelegate!
    var segueIdentifier : String!
    
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var detailIcon: UIImageView!
    @IBOutlet var detailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func performAction (sender : AnyObject!) {
        delegate.detailButtonClicked(segueIdentifier)
    }
}
