//
//  UserViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var defaultUser = ""
    var shouldSearchUser = true
    var isLoading = true {
        didSet {
            infoImageView.isHidden = !isLoading
            infoTextLabel.isHidden = !isLoading
            tableView.isHidden = isLoading
        }
    }
    
    var user : User! {
        didSet {
            if !shouldSearchUser {
                return
            }
            
            isLoading = false
            if user != nil {
                self.navigationItem.title = user.name ?? "No Name :("
                if #available(iOS 11.0, *) {
                    self.navigationItem.searchController?.isActive = false
                }
                repos.removeAll()
                page = 1
                containsMoreRepos = true
                tableView.scrollToRow(at:  IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
                
                tableView.reloadData()
                displayUser (page: page)
            } else {
                if #available(iOS 11.0, *) {
                    self.navigationItem.searchController?.isActive = true
                }
            }
        }
    }
    
    var repos : [Repo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var containsMoreRepos = false
    var page = 1
    
    let defaults = UserDefaults.standard
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var infoImageView : UIImageView!
    @IBOutlet var infoTextLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = 55
        
        if !shouldSearchUser {
            displayUser(page: page)
            isLoading = false
            return
        }
        
        isLoading = true
        
        if let user = defaults.string(forKey: "user") {
            defaultUser = user
            searchUser(defaultUser)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUser(page : Int) {
        infoTextLabel.text = "Loading"
        DataManager.shared.getRepos(user: user, options: ["page" : page], block: { (repos, error) -> Void in
            
            if error != nil {
                return
            }
            
            if repos?.count == 0 || repos == nil {
                self.containsMoreRepos = false
            }
            
            
            if let repos = repos {
                self.repos.append(contentsOf: repos)
            }
            self.tableView.isHidden = false
            
        })
    }
    
    func searchUser(_ userStr : String) {
        DataManager.shared.getUser(username: userStr, block: { (user, error) -> Void in
            if let error = error {
                self.isLoading = true
                self.infoTextLabel.text = error.description
                
                switch error.code {
                case 403:
                    self.infoImageView.image =  #imageLiteral(resourceName: "muertosoctocat")
                case 404:
                    self.infoImageView.image = #imageLiteral(resourceName: "obiwanoctocat")
                    break;
                case 505:
                    self.infoImageView.image = #imageLiteral(resourceName: "deckfailoctocat")
                    break;
                default:
                    break;
                }
                
                return
            }
            self.user = user
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? RepoViewController {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let repo = repos[indexPath?.row ?? 0]
            vc.repo = repo
        }
        
        if let vc = segue.destination as? SearchViewController {
            vc.delegate = self
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        }
    }
}

// MARK: - UITableViewDataSource
extension UserViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return section == 0 ? user == nil ? 0 : 1 : repos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        
        let identifier = indexPath.section == 0 ? "UserInfoCell" : "RepoCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        
        if let cell = cell as? UserInfoTableViewCell {
            cell.nameLabel.text = "@" + user.username
            
            if let individual = user as? User.Individual {
                cell.usernameLabel.text = "User"
                cell.companyLabel.text = individual.company
            } else if user is User.Organization {
                cell.usernameLabel.text = "Organization"
                cell.companyLabel.text = nil
            }
            cell.locationLabel.text = user.location
            cell.emailLabel.text = user.email
            cell.urlLabel.text = user.url
            
            cell.avatarImageView.image = #imageLiteral(resourceName: "Oct Icon")
            user.fetchImageIfNeeded({ (data, error) -> Void in
                cell.avatarImageView.image = UIImage(data: data!)
            })
            
        }
        if let cell = cell as? RepoTableViewCell {
            
            let repo = repos[indexPath.row ]
            cell.repoNameLabel.text = repo.name
            cell.starsLabel.text = "\(repo.stargazersCount)"
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableViewAutomaticDimension : 55
    }

}

extension UserViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repos.count - 1 && containsMoreRepos {
            page += 1
            displayUser(page: page)
        }
    }
    
}

// MARK: - SearchViewControllerDelegate
extension UserViewController : SearchViewControllerDelegate {
    func searchViewController(_ searchViewController: SearchViewController, didInputUser user: String) {
        self.navigationItem.title = nil
        infoTextLabel.text = "Loading"
        infoImageView.image = #imageLiteral(resourceName: "jetpackoctocat")
        
        tableView.isHidden = true
        
        defaultUser = user
        defaults.set(defaultUser, forKey: "user")
        
        searchUser(defaultUser)
    }
}

// MARK: - UISearchBarDelegate
extension UserViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        

        infoTextLabel.text = "Loading"
        infoImageView.image = #imageLiteral(resourceName: "jetpackoctocat")
        
        isLoading = true
        
        defaultUser = searchBar.text ?? ""
        defaults.set(defaultUser, forKey: "user")
        
        searchUser(defaultUser)
        
    }
}

