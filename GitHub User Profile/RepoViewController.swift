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
    var repo : Repo!
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRepoBranchesSegue" {
            let vc = segue.destination as? RepoBranchesViewController
            vc?.repo = repo
            vc?.user = user
        } else if segue.identifier == "showRepoCommitsSegue" {
            let vc = segue.destination as? RepoCommitsViewController
            vc?.repo = repo
            //vc?.user = user
            vc?.commits = commits
        }
    }

    
    @IBAction func viewOnGitHubAction (_ sender : AnyObject!) {
        
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Do you want to open this address in Safari?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        let photoLibraryAction = UIAlertAction(title: "Open in Safari", style: .default) { (action) in
            
            if let url = self.repo.url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return repoSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if (repoSettings[indexPath.section]["Type"] == "description") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "repoDescriptionCell", for: indexPath) as! RepoDescriptionTableViewCell
            cell.descriptionTextView.text = repo.description
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepoDetailPartCell", for: indexPath) as! RepoDetailPartTableViewCell
            cell.delegate = self
            if (repoSettings[indexPath.section]["Type"] == "branches") {
                cell.detailLabel.text = repo.defaultBranch
                cell.detailIcon.image = UIImage(named: "BranchIcon")
                cell.detailButton.setTitle("View More Branches", for: UIControlState())
                cell.segueIdentifier = "showRepoBranchesSegue"
            } else if (repoSettings[indexPath.section]["Type"] == "commits") {
                cell.detailLabel.text = "Commits"
                DataManager.getCommits(user.username, repo: repo.name, options: nil) { (records, error) -> Void in
                    if let records = records as? [Commit] {
                        self.commits = records
                        
                        cell.detailLabel.text =  "\(records.count) Commits"
                        if records.count >= 100 {
                            cell.detailLabel.text =  "\(records.count)+ Commits"
                        }
                    }
                }
                cell.detailIcon.image = UIImage(named: "HistoryIcon")
                cell.detailButton.setTitle("View Commits", for: UIControlState())
                cell.segueIdentifier = "showRepoCommitsSegue"
            }
            cell.detailIcon.addImageInsets(Extension.Edge)
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    func detailButtonClicked(_ segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)

    }
}
