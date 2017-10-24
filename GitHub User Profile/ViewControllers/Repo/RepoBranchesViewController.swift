//
//  RepoBranchesViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/22/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

protocol RepoBranchesViewControllerDelegate {
    func repoBranchesViewController(_ repoBranchesViewController: RepoBranchesViewController, didSelect branch: Branch)
}

class RepoBranchesViewController: UIViewController {
    
    var delegate : RepoBranchesViewControllerDelegate?
    
    var user : User!
    var repo : Repo!
    
    @IBOutlet var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = repo.name
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        DataManager.getBranches(user.username, repo: repo.name, options: nil, block: { (branches, error) in
            self.repo.branches = branches ?? []
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Table view data source
extension RepoBranchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return repo.branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoBranchCell", for: indexPath) 
        
        let branch = repo.branches[indexPath.row ]
        
        cell.textLabel?.text = branch.name
        cell.detailTextLabel?.text = repo.defaultBranch == branch.name ? "Default" : ""
        
        cell.imageView?.image = UIImage(named: "BranchIcon")
        cell.imageView?.addImageInsets(UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0))

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

// MARK: - Table view data source
extension RepoBranchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch = repo.branches[indexPath.row]
        self.delegate?.repoBranchesViewController(self, didSelect: branch)
    }
}
