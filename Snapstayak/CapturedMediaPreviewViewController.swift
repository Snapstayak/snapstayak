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

protocol CapturedMediaPreviewPostDelegate: class {
    func newPhotoPostWithData(photo: UIImage)
    func newVideoPostWithData(videoURL: URL)
}

class CapturedMediaPreviewViewController: UIViewController {
    weak var viewControllerDelegate: CapturedMediaPreviewViewControllerDelegate?
    weak var postDelegate: CapturedMediaPreviewPostDelegate?
    var mediaContainerView: UIView!
    var cancelButton: UIButton!
    var sendButton: SendButton!
    private var cancelButtonImageView: UIImageView!
    
    func dismissViewController() {
        self.viewControllerDelegate?.capturedMediaPreviewViewControllerWillDismiss(self)
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
    
    func setUpSendButton() {
        let sendFrameButtonHeight: CGFloat = 90/1.5
        let sendButtonFrame = CGRect(x: self.view.frame.maxX - sendFrameButtonHeight - 16, y: self.view.frame.maxY - sendFrameButtonHeight - 16, width: sendFrameButtonHeight, height: sendFrameButtonHeight)
        self.sendButton = SendButton(frame: sendButtonFrame)
        self.sendButton.addTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
    }
    
    func sendButtonTapped() {
        self.dismiss(animated: false) {
            self.containerSwipeNavigationController?.showEmbeddedView(position: .center)
        }
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

