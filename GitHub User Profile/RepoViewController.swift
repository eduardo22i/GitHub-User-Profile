//
//  RepoViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RepoDetailPartDelegate {

    var user : User!
    var repo = Repo()
    var commits : [Commit] = []
    var repoSettings = [ ["Label" : "Description", "Type": "description"], ["Label" : "Branches", "Type": "branches"], ["Label" : "Commits", "Type": "commits"] ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = repo.name
        
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
        if segue.identifier == "showRepoBranchesSegue" {
            let vc = segue.destinationViewController as? RepoBranchesViewController
            vc?.repo = repo
            vc?.user = user
        } else if segue.identifier == "showRepoCommitsSegue" {
            let vc = segue.destinationViewController as? RepoCommitsViewController
            vc?.repo = repo
            //vc?.user = user
            vc?.commits = commits
        }
    }

    
    @IBAction func viewOnGitHubAction (sender : AnyObject!) {
        
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Do you want to open this address in Safari?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        let photoLibraryAction = UIAlertAction(title: "Open in Safari", style: .Default) { (action) in
            
            let url = NSURL(string: self.repo.html_url)
            UIApplication.sharedApplication().openURL(url!)
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
       
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return repoSettings.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if (repoSettings[indexPath.section]["Type"] == "description") {
            let cell = tableView.dequeueReusableCellWithIdentifier("repoDescriptionCell", forIndexPath: indexPath) as! RepoDescriptionTableViewCell
            cell.descriptionTextView.text = repo.alternateDescription
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("RepoDetailPartCell", forIndexPath: indexPath) as! RepoDetailPartTableViewCell
            cell.delegate = self
            if (repoSettings[indexPath.section]["Type"] == "branches") {
                cell.detailLabel.text = repo.default_branch
                cell.detailIcon.image = UIImage(named: "BranchIcon")
                cell.detailButton.setTitle("View More Branches", forState: UIControlState.Normal)
                cell.segueIdentifier = "showRepoBranchesSegue"
            } else if (repoSettings[indexPath.section]["Type"] == "commits") {
                cell.detailLabel.text = "Commits"
                DataManager.getCommits(user.login, repo: repo.name, options: nil) { (records, error) -> Void in
                    if let records = records as? [Commit] {
                        self.commits = records
                        
                        cell.detailLabel.text =  "\(records.count ?? 0) Commits"
                        if records.count >= 100 {
                            cell.detailLabel.text =  "\(records.count ?? 100)+ Commits"
                        }
                    }
                }
                cell.detailIcon.image = UIImage(named: "HistoryIcon")
                cell.detailButton.setTitle("View Commits", forState: UIControlState.Normal)
                cell.segueIdentifier = "showRepoCommitsSegue"
            }
            cell.detailIcon.addImageInsets(Extension.Edge)
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return repoSettings[indexPath.section]["Type"] == "description" ? 50 : 65
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

    //MARK: - RepoDetailPartDelegate
    func detailButtonClicked(segueIdentifier: String) {
        self.performSegueWithIdentifier(segueIdentifier, sender: self)

    }
}
