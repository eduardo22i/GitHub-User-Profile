//
//  RepoCommitsViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/26/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class RepoCommitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var user : User!
    var repo : Repo!
    
    var commits : [Commit] = [ ]
    var commitsUsers = NSMutableArray()
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //DataManager.getCommits(user.login, repo: repo.name, options : nil) { (records, error) -> Void in
        //    if let commits = records as? [Commit] {
                let commitsUsersLogin = NSMutableSet()
                for commit in commits {
                    self.commits.append(commit)
                    if let login = commit.author["login"] as? String {
                        if !commitsUsersLogin.containsObject(login) {
                            commitsUsersLogin.addObject(login)
                        	DataManager.getUser(login, block: { (user, error) -> Void in
                                if let user = user {
                                    user.downloadImage({ (data, error) -> Void in
                                        self.tableView.reloadData()
                                    })
                                    self.commitsUsers.addObject(user)
                                }
                                self.tableView.reloadData()
                            })
                        } 
                    }
                }
        //    }
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return commits.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("repoBranchCell", forIndexPath: indexPath) 
        
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = UIImage(named: "Oct Icon")
        cell.imageView?.addImageInsets(UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        
        let commit = commits[indexPath.row ]
        if let message = commit.commit["message"] as? String {
            cell.textLabel?.text = message
        }
        
        for usercommit in self.commitsUsers {
            if let login = commit.author["login"] as? String, let usercommit = usercommit as? User {
                if login == usercommit.login {
                    cell.detailTextLabel?.text = "\(usercommit.login) authored"
                    
                    if let data = usercommit.imageData {
                        cell.imageView!.image = UIImage(data: data)
                        cell.imageView?.clipsToBounds = true
                        cell.imageView?.addImageInsets(UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                        cell.imageView?.addRoundedCorner()
                        
                    }
                    
                }
            }
        }
        
        if let date = commit.commit["author"]!["date"] as? String {
            let userCommitLabel = cell.detailTextLabel?.text ?? ""
            cell.detailTextLabel?.text = "\(userCommitLabel) on \(date)"
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let commit = commits[indexPath.row ]
        
        for usercommit in self.commitsUsers {
            if let login = commit.author["login"] as? String, let usercommit = usercommit as? User {
                if login == usercommit.login {
                    let vc = storyboard?.instantiateViewControllerWithIdentifier("viewController") as! ViewController
                    
                    vc.defaultUser = login
                    vc.shouldSearchUser = false
                    vc.user = usercommit
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                }
            }
        }
        
        
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
