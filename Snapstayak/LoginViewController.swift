//
//  LoginViewController.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/25/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var loginButtonContainerView: UIView!
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailContainerView.layer.cornerRadius = 5.0;
        loginButtonContainerView.layer.cornerRadius = 5.0;
        
        loginButtonContainerView.layer.borderWidth = 2;
        loginButtonContainerView.layer.borderColor = UIColor(white: 1, alpha: 0.15).cgColor;
        
        emailField.attributedPlaceholder = NSAttributedString(string: emailField.placeholder ?? "", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginBtn(_ sender: Any) {
        let newUser = User()
        newUser.signup(email: emailField.text ?? "")
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
