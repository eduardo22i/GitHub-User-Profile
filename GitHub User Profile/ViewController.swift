//
//  ViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserSearchDelegate {

    var defaultUser = ""
    var shouldSearchUser = true
    
    var user : User! {
        didSet {
            if !shouldSearchUser {
                return
            }
            tableView.isHidden = false
            tableView.reloadData()
            displayUser ()
        }
    }
    
    var repos : [Repo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let defaults = UserDefaults.standard
    
    @IBOutlet var infoImageView : UIImageView!
    @IBOutlet var infoTextLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if !shouldSearchUser {
            displayUser ()
            return
        }
        
        tableView.isHidden = true
        
        if let user = defaults.string(forKey: "user") {
            defaultUser = user
            searchUser(defaultUser)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayUser () {
        infoTextLabel.text = "Loading"
        DataManager.getRepos(user.username, options: ["page" : 1], block: { (repos, error) -> Void in
            
            if error != nil {
                return
            }
            
            if let repos = repos as? [Repo] {
                self.repos = repos
            }
            self.tableView.isHidden = false
            
        })
    }
    
    func searchUser (_ userStr : String) {
        DataManager.getUser(userStr, block: { (user, error) -> Void in
            if let error = error {
                self.infoTextLabel.text = error.localizedDescription
                self.tableView.isHidden = true
                
                switch error._code {
                case 403:
                    self.infoImageView.image = UIImage(named: "muertosoctocat")
                case 404:
                    self.infoImageView.image = UIImage(named: "obiwanoctocat")
                    break;
                case 505:
                    self.infoImageView.image = UIImage(named: "deckfailoctocat")
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
        if segue.identifier == "showRepoSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let repo = repos[indexPath?.row ?? 0]
            let vc = segue.destination as? RepoViewController
            vc?.repo = repo
            vc?.user = user
        } else {
            let vc = segue.destination as? SearchViewController
            vc?.delegate = self
            vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return section == 0 ? user == nil ? 0 : 1 : repos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               // Configure the cell...
        if indexPath.section == 0 {
            
            let cellu = tableView.dequeueReusableCell(withIdentifier: "userInfoCellIdentifier", for: indexPath) as! UserInfoTableViewCell
            cellu.userNameLabel.text = user.name ?? "No Name :("
            cellu.usernameLabel.text = user.username
            cellu.userCompanyLabel.text = user.company ?? "No Company :("
            cellu.userLocationLabel.text = user.location ?? "No Location :("
            cellu.userEmailLabel.text = user.email ?? "No Email :("
            cellu.userURLLabel.text = user.url ?? "No URL :("
            
            cellu.userImageView.image = UIImage(named: "Oct Icon")
            user.downloadImage({ (data, error) -> Void in
                cellu.userImageView.image = UIImage(data: data!)
            })
            cellu.userImageView.addRoundedCorner()
            
            return cellu
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RepoTableViewCell
            
            let repo = repos[indexPath.row ]
            cell.repoNameLabel.text = repo.name
            cell.starsLabel.text = "\(repo.stargazers_count)"
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 55
    }
    
    //MARK: - UserSearchDelegate
    
    func didInputUser(_ userStr: String) {
        infoTextLabel.text = "Loading"
        infoImageView.image = UIImage(named: "jetpackoctocat")
        
        tableView.isHidden = true
        
        defaultUser = userStr
        defaults.set(defaultUser, forKey: "user")

        searchUser(defaultUser)
    }
    
}

