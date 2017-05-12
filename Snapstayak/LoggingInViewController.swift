//
//  LoggingInViewController.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 5/11/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class LoggingInViewController: UIViewController {
    
    var token: String!

    override func viewDidAppear(_ animated: Bool) {
        if token == nil {
            dismiss(animated: false, completion: nil)
        } else {
            Snapstayak.api(["login": token], endpoint: "users/login/", completion: { dict in
                //  if(dict?["uuid"] as? String == UUID().uuidString) {
                if(dict?["email"] as? String != "") { // if is valid string
                    let newUser = User()
                    newUser.id = dict?["id"] as? Int
                    newUser.email = dict?["email"] as? String
                    if(User.login(user: newUser)){
                        let vc = (UIApplication.shared.delegate as! AppDelegate).buildSwipeNavController()
                        self.present(vc, animated: true, completion: nil)
                    }
                } else {
                    alert(title: "Uh oh!", message: "That login token is invalid for this device!", button: "Try Again")
                    self.dismiss(animated: true, completion: nil)
                }
            })
            token = nil
        }
    }

    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
