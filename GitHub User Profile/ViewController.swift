//
//  ViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserSearchDelegate {

    let defaultUser = "jackoplane"
    
    var user : User! {
        didSet {
                if let username = user.login {
                    infoText.text = "Loading"
                    DataManager.getRepos(username, block: { (repos, error) -> Void in
                        if error != nil {
                            return
                        }
                        self.tableView.hidden = false
                        self.repos = repos!
                    })
                }
            
        }
    }
    
    var repos : [Repo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet var infoText : UILabel!
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.hidden = true
        searchUser(defaultUser)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchUser (userStr : String) {
        DataManager.getUser(userStr, block: { (user, error) -> Void in
            if error != nil {
                self.infoText.text = "User Not Found :("
                self.tableView.hidden = true
                
                return
            }
            self.user = user
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRepoSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            let repo = repos[indexPath?.row ?? 0]
            let vc = segue.destinationViewController as? RepoViewController
            vc?.repo = repo
            
        } else {
            let vc = segue.destinationViewController as? SearchViewController
            vc?.delegate = self
            vc?.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return section == 0 ? user == nil ? 0 : 1 : repos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
               // Configure the cell...
        if indexPath.section == 0 {
            
            let cellu = tableView.dequeueReusableCellWithIdentifier("userInfoCellIdentifier", forIndexPath: indexPath) as! UserInfoTableViewCell
            cellu.userNameLabel.text = user.name ?? "No Name :("
            cellu.usernameLabel.text = user.login
            cellu.userCompanyLabel.text = user.company ?? "No Company :("
            cellu.userLocationLabel.text = user.location ?? "No Location :("
            cellu.userEmailLabel.text = user.email ?? "No Email :("
            cellu.userURLLabel.text = user.blog ?? "No URL :("
            
            cellu.userImageView.image = UIImage(named: "Oct Icon")
            user.downloadImage({ (data, error) -> Void in
                cellu.userImageView.image = UIImage(data: data!)
            })
            cellu.userImageView.addRoundedCorner()
            
            return cellu
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! RepoTableViewCell
            
            let repo = repos[indexPath.row ]
            cell.repoNameLabel.text = repo.name
            cell.starsLabel.text = "\(repo.stargazers_count)"
            
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 150 : 55
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    //MARK: - UserSearchDelegate
    
    func didInputUser(userStr: String) {
        infoText.text = "Loading"
        tableView.hidden = true
        
        searchUser(userStr)
    }
    
}

