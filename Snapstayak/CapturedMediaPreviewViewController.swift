//
//  CapturedMediaPreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwipeNavigationController

protocol CapturedMediaPreviewViewControllerDelegate: class {
    func capturedMediaPreviewViewControllerWillDismiss(_ capturedMediaVC: CapturedMediaPreviewViewController)
}

class CapturedMediaPreviewViewController: UIViewController {
    weak var delegate: CapturedMediaPreviewViewControllerDelegate?
    var mediaContainerView: UIView!
    var cancelButton: UIButton!
    private var cancelButtonImageView: UIImageView!
    
    func dismissViewController() {
        self.delegate?.capturedMediaPreviewViewControllerWillDismiss(self)
        self.dismiss(animated: false, completion: nil)
    }
    
    func setUpCancelButton() {
        let cancelButtonImageViewFrame = CGRect(x: 16.0, y: 16.0, width: 24.0, height: 24.0)
        self.cancelButtonImageView = UIImageView(frame: cancelButtonImageViewFrame)
        self.cancelButtonImageView.image = #imageLiteral(resourceName: "cancel")
        self.view.addSubview(self.cancelButtonImageView)
        let cancelButtonFrame = CGRect(x: 0, y: 0, width: cancelButtonImageViewFrame.maxX + cancelButtonImageViewFrame.width/1.5, height: cancelButtonImageViewFrame.maxY + cancelButtonImageViewFrame.height/1.5)
        self.cancelButton = UIButton(frame: cancelButtonFrame)
        self.cancelButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
}

