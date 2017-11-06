//
//  LoginViewController.swift
//  GitHub iOS
//
//  Created by Eduardo Irias on 10/31/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func setUsernameTextFieldResponderAction(_ sender: Any) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func setPasswordTextFieldResponderAction(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        if username == "" || password == "" {
            return
        }
        
        DataManager.shared.postLogin(username: username, password: password) { (user, error) in
            // TODO: - Add Error alert
            //if let error = error  {
                //error.localizedDescription
            //}
            if user != nil {
                self.dismiss(animated: true)
            }
        }
    }

    @IBAction func forgotPasswordAction(_ sender: Any) {
        guard let url = URL(string: "https://github.com/password_reset") else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField == textField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginAction(textField)
        }
        return true
    }
        
}
