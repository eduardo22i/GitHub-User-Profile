//
//  OrganizationsTableViewCell.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 11/19/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit

@objc protocol OrganizationsTableViewCellDelegate {
    func organizationsTableViewCell(_ organizationsTableViewCell: OrganizationsTableViewCell, didSelectItemAt indexPath: IndexPath)
}

class OrganizationsTableViewCell: UITableViewCell {

    weak var delegate : OrganizationsTableViewCellDelegate?
    
    var organizations = [User.Organization]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OrganizationsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return organizations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let organization = organizations[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrganizationCell", for: indexPath) as! OrganizationCollectionViewCell
        cell.tag = indexPath.row
        cell.iconImageView.image = nil
        
        organization.fetchImageIfNeeded { (data, error) in
            if indexPath.row == cell.tag, let data = data  {
                cell.iconImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
    
}

extension OrganizationsTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.organizationsTableViewCell(self, didSelectItemAt: indexPath)
    }
}

