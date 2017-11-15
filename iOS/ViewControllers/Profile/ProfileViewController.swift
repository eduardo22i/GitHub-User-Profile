//
//  ProfileViewController.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/31/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user : User? {
        didSet {
            self.navigationItem.title = user?.name
            tableView.reloadData()
        }
    }
    
    @IBOutlet var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 55
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.user = User.current
        
        if User.current == nil {
            UIApplication.shared.keyWindow?.rootViewController?.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITableViewDataSource
extension ProfileViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 0 ? user == nil ? 0 : 1 : user?.repos.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        let identifier = indexPath.section == 0 ? "UserInfoCell" : "RepoCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        if let cell = cell as? UserInfoTableViewCell {
            guard let user = user else {return cell}
            
            cell.usernameLabel.text = user.username
            cell.typeLabel.text = user.type?.rawValue
            cell.companyLabel.text = user.company
            cell.locationLabel.text = user.location
            cell.emailLabel.text = user.email
            cell.urlLabel.text = user.url
            
            cell.avatarImageView.image = #imageLiteral(resourceName: "Oct Icon")
            user.fetchImageIfNeeded({ (data, error) -> Void in
                guard let data = data else {
                    return
                }
                cell.avatarImageView.image = UIImage(data: data)
            })
            
        }
        if let cell = cell as? RepoTableViewCell {
            
            let repo = user!.repos[indexPath.row ]
            cell.repoNameLabel.text = repo.name
            cell.starsLabel.text = "\(repo.stargazersCount)"
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 55
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
}
