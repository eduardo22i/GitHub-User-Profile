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

    static var userSearchInput = ""
    
    var delegate : UserSearchDelegate!
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.text = SearchViewController.userSearchInput
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        SearchViewController.userSearchInput = searchBar.text
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        SearchViewController.userSearchInput = ""
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SearchViewController.userSearchInput = searchBar.text
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            if let delegate = self.delegate {
                delegate.didInputUser(searchBar.text)
            }
        })
    }
}
