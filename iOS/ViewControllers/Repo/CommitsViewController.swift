//
//  CommitsViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/26/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class CommitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var commits : [Commit] = []
        
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return commits.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoBranchCell", for: indexPath) 
        
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = UIImage(named: "Oct Icon")
        cell.imageView?.addImageInsets(UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        
        let commit = commits[indexPath.row ]
        
        cell.textLabel?.text = commit.message
        
        if let date = commit.date, let name = commit.user?.name {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateStyle = .medium
            let dateString = dateFormatter.string(from: date)
            
            cell.detailTextLabel?.text = "\(dateString) by \(name)"
        }
        
        cell.imageView?.image = #imageLiteral(resourceName: "Oct Icon")
        
        commit.user?.downloadImage({ (data, error) -> Void in
            cell.imageView?.image = UIImage(data: data!)
            cell.imageView?.addImageInsets(UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        })
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commit = commits[indexPath.row ]
        
        if let user = commit.user {
            let vc = storyboard?.instantiateViewController(withIdentifier: "viewController") as! UserViewController
            
            vc.defaultUser = user.username
            vc.shouldSearchUser = false
            vc.user = user
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
