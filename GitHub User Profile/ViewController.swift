//
//  ViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user : User!
    var repos : [Repo] = []
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //println(DataManager.getUser("eduardo22i").repos_url)
        user = DataManager.getUser("eduardo22i")
        repos = DataManager.getRepos("eduardo22i")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return section == 0 ? 1 : repos.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
               // Configure the cell...
        if indexPath.section == 0 {
            
            let cellu = tableView.dequeueReusableCellWithIdentifier("userInfoCellIdentifier", forIndexPath: indexPath) as! UserInfoTableViewCell
            cellu.userNameLabel.text = user.name
            cellu.usernameLabel.text = user.login
            cellu.userCompanyLabel.text = user.company
            cellu.userLocationLabel.text = user.location
            cellu.userEmailLabel.text = user.email
            cellu.userURLLabel.text = user.blog
            
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

}

