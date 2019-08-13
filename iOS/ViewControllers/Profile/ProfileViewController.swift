//
//  ProfileViewController.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/31/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let dataManager = DataManager.shared
    
    var user : User? {
        didSet {
            self.navigationItem.title = user?.name
            tableView.reloadData()
        }
    }
    
    var organizations = [User.Organization]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var repoPagination = 1
    var isLoadingRepos = false
    
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
        
        self.user = User.current
        
        dataManager.getCurrentUserOrgs { (organizations, error) in
            self.organizations = organizations ?? []
        }
        
        loadRepos(page: repoPagination)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        guard self.user != nil else {
            self.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
            return
        }
    }
    
    func loadRepos(page: Int) {
        if isLoadingRepos { return }
        isLoadingRepos = true
        dataManager.getCurrentUserRepos(options: ["page": page]) { (repos, erro) in
            if page == 1 {
                self.user?.repos.removeAll()
            }
            self.user?.repos.append(contentsOf: repos ?? [])
            self.tableView.reloadData()
            self.isLoadingRepos = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? UserViewController {
            
            let indexPath = (tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! OrganizationsTableViewCell).collectionView.indexPath(for: sender as! UICollectionViewCell)
            vc.user = organizations[indexPath?.row ?? 0]            
        }
        
        if let vc = (segue.destination as? UINavigationController)?.topViewController as? LoginViewController {
            vc.delegate = self
        }
    }
    
}


// MARK: - UITableViewDataSource
extension ProfileViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return user == nil ? 0 : 2
        case 1:
            return 1
        case 2:
            return user?.repos.count ?? 0
        default:
            return 0
        }
    }
    
    func cellIdentifier(indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return indexPath.row == 0 ? "UserInfoCell" : "DescriptionCell"
        case 1:
            return "OrganizationsCell"
        case 2:
            return "RepoCell"
        default:
            return ""
        }
    }
    
    func configureCell(_ cell: RepoTableViewCell, at repo: Repo) {
        cell.repoNameLabel.text = repo.name
        cell.descriptionLabel.text = repo.description
        cell.starsLabel.text = "\(repo.stargazersCount)"
        cell.languageLabel.text = repo.language
        
        if repo.isForked {
            cell.repoImageView.image = #imageLiteral(resourceName: "BranchIcon")
        } else if repo.isPrivate {
            cell.repoImageView.image = #imageLiteral(resourceName: "PrivateIcon")
        } else {
            cell.repoImageView.image = #imageLiteral(resourceName: "RepoIcon")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        let identifier = cellIdentifier(indexPath: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        guard let user = user else { return cell }

        if let cell = cell as? UserInfoTableViewCell {
            cell.usernameLabel.text = "@\(user.username ?? "")"
            cell.typeLabel.text = user.type?.rawValue
            if let user = user as? User.Individual {
                cell.companyLabel.text = user.company
            }
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
        
        if let cell = cell as? TitleTableViewCell {
            cell.titleLabel.text = user.bio
        }
        
        if let cell = cell as? OrganizationsTableViewCell {
            cell.organizations = organizations
        }
        
        if let cell = cell as? RepoTableViewCell {
            let repo = user.repos[indexPath.row ]
            configureCell(cell, at: repo)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTitleCell") as? TitleTableViewCell
        cell?.titleLabel.text = section == 1 ? "Organizations" : "Repositories"
        return cell?.contentView
    }
}

extension ProfileViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 48
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let user = self.user else { return }

        if indexPath.section == 2 && indexPath.row == user.repos.count - 1 && (self.user?.reposCount ?? 0) > indexPath.row {
            print("LOAD MORE")
            repoPagination += 1
            loadRepos(page: repoPagination)
        }
    }
    
}
extension ProfileViewController : LoginViewControllerDelegate {
    func loginViewController(_ loginViewController: LoginViewController, didLoginWith user: User) {
        self.user = user
        loginViewController.dismiss(animated: true)
    }
    
    func didCancel(_ loginViewController: LoginViewController) {
        loginViewController.dismiss(animated: true) {
            self.tabBarController?.selectedIndex = 0
        }
    }
}
