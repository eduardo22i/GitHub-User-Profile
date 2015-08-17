//
//  SearchViewController.swift
//  GitHub User Profile
//
//  Created by Eduardo Irías on 8/17/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit

protocol UserSearchDelegate {
    func didInputUser(user : String)
}

class SearchViewController: UIViewController, UISearchBarDelegate {

    var delegate : UserSearchDelegate!
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.becomeFirstResponder()
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let delegate = self.delegate {
                delegate.didInputUser(searchBar.text)
            }
        })
    }
}
