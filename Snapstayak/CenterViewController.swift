//
//  CenterViewController.swift
//  Snapstayak
//
//  Created by Tejen Hasmukh Patel on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            self.present(storyboard.instantiateInitialViewController()!, animated: true)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CenterViewController: NewPostDelegate {
    func newPostWithCapturedMedia(_ capturedMedia: CapturedMedia) {
        print("New Post!")
    }
}
