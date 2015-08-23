//
//  RepoViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    var user : User!
    var repo = Repo()
    
    @IBOutlet var branchLabel: UILabel!
    @IBOutlet var branchIcon: UIImageView!
    @IBOutlet var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = repo.name
        branchLabel.text = repo.default_branch
        descriptionTextView.text = repo.alternateDescription
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
}
