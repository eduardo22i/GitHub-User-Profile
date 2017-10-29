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
    var repo : Repo!
    
    var currentBranch : Branch? {
        didSet {
            self.branchLabel.text = currentBranch?.name
            
            guard let currentBranch = currentBranch else { return }
            
            DataManager.getCommits(user.username, repo: repo.name, branch: currentBranch.name!, options: nil) { (commits, error) in
                
                if let commits = commits {
                    currentBranch.commits = commits
                    
                    let plusString = commits.count >= 100 ? "+" : ""
                    self.commitsButton.setTitleWithoutAnimation("\(commits.count)\(plusString) Commits", for: .normal)
                }
            }
        }
    }
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var branchLabel: UILabel!
    @IBOutlet weak var commitsButton: UIButton!
    @IBOutlet weak var readmeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = repo.name

        currentBranch = repo.branches.first
        
        self.descriptionTextView.removeInnerSpacing()

        self.readmeTextView.removeInnerSpacing()
        
        self.descriptionTextView.text = repo.description
        
        DataManager.shared.getReadme(username: user.username, repo: repo.name) { (file, error) in
            if let rawContent = file?.content {
                let content = String(data: rawContent, encoding: String.Encoding.utf8)
                
                var attributedString = NSMutableAttributedString(string: content!)
                
                let range = NSRange(location: 0, length: attributedString.string.count)
                attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body), range: range )
                
                
                attributedString = attributedString.replace(tag: "###", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3 )])
                
                attributedString = attributedString.replace(tag: "##", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2 )])
                
                attributedString = attributedString.replace(tag: "#", withAttributes: [NSAttributedStringKey.font : UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)])
                
                self.readmeTextView.attributedText = attributedString
                
                self.downloadImage(attributedString: attributedString)
            }
            
        }
    }
    
    func downloadImage(attributedString: NSMutableAttributedString) {
        
        DispatchQueue.init(label: "Download Markup Images").async {
            
            let plainString = attributedString.string
            
            if let range = plainString.range(of: "\\!\\[[\\w\\s]*\\]\\(([^)]+)\\)", options: .regularExpression, range: plainString.startIndex..<plainString.endIndex, locale: nil) {
                
                let imageFormatString = String(plainString[range]) + ""
                
                
                if let urlRange = imageFormatString.range(of: "\\(([^)]+)\\)", options: .regularExpression, range: imageFormatString.startIndex..<imageFormatString.endIndex, locale: nil) {
                    
                    var imageUrlString  = String(imageFormatString[urlRange])
                    
                    if let i = imageUrlString.characters.index(of: "(") {
                        imageUrlString.remove(at: i)
                    }
                    
                    if let i = imageUrlString.characters.index(of: ")") {
                        imageUrlString.remove(at: i)
                    }
                    
                    if let url = URL(string: String(imageUrlString)) {
                        let request = URLRequest(url: url)
                        HTTPManager.make(request: request, completeBlock: { (data, error) in
                            
                            if let data = data {
                                let textAttachment = NSTextAttachment()
                                textAttachment.image = UIImage(data: data)
                                let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                                
                                attributedString.replaceCharacters(in: NSRange(range, in: plainString), with: attrStringWithImage)
                                
                            } else {
                                attributedString.replaceCharacters(in: NSRange(range, in: plainString), with: "❓")
                            }
                            
                            self.readmeTextView.attributedText = attributedString
                            self.downloadImage(attributedString: attributedString)
                        })
                    }
                }
                
            }
        }
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
      
        if let vc = (segue.destination as? UINavigationController)?.topViewController as?  BranchesViewController {
            vc.delegate = self
            vc.repo = repo
            vc.user = user
        }
        
        if let vc = segue.destination as? CommitsViewController {
            vc.commits = currentBranch?.commits ?? []
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
    
}

extension RepoViewController: BranchesViewControllerDelegate {
    
    func repoBranchesViewController(_ repoBranchesViewController: BranchesViewController, didSelect branch: Branch) {
        self.currentBranch = branch
        repoBranchesViewController.dismiss(animated: true, completion: nil)
    }
}
