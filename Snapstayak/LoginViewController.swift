//
//  LoginViewController.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/25/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var newUser: User!
    var token: String!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
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
        
        emailField.delegate = self
        emailField.attributedPlaceholder = NSAttributedString(string: emailField.placeholder ?? "", attributes: [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 0.7)]);
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        loginIndicator.stopAnimating()
        loginButton.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        if token != nil {
            User.logout()
            performSegue(withIdentifier: "loggingIn", sender: nil)
        } else if let _ = User.currentUser {
            let vc = (UIApplication.shared.delegate as! AppDelegate).buildSwipeNavController()
            self.present(vc, animated: true, completion: { 
                UIView.animate(withDuration: 1, animations: {
                    self.view.alpha = 1
                }, completion: nil)
            })
        } else {
            // TODO: - REVERT THIS.
//            UIView.animate(withDuration: 1, animations: {
//                self.view.alpha = 1
//            }, completion: nil)
            let vc = (UIApplication.shared.delegate as! AppDelegate).buildSwipeNavController()
            self.present(vc, animated: true, completion: {
                UIView.animate(withDuration: 1, animations: {
                    self.view.alpha = 1
                }, completion: nil)
            })
        }
    }
    
    @IBAction func onLoginBtn(_ sender: Any?) {
        loginIndicator.startAnimating()
        loginButton.isHidden = true
        
        newUser = User()
        newUser.signup(email: emailField.text ?? "") { user in
            if(user?.id == nil) {
                self.loginIndicator.stopAnimating()
                self.loginButton.isHidden = false
            } else {
                self.performSegue(withIdentifier: "checkEmail", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "loggingIn" {
            let vc = segue.destination as! LoggingInViewController
            vc.token = token
            token = nil
        }
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onLoginBtn(nil)
        return true
    }
}
