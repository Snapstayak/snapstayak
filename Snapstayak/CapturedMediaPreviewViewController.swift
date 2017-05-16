//
//  CapturedMediaPreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwipeNavigationController

protocol CapturedMediaPreviewDelegate: class {
    func capturedMediaPreviewViewController(_ capturedMediaVC: CapturedMediaPreviewViewController, userDidPressSendWithCapturedMedia capturedMedia: CapturedMedia)
}

class CapturedMediaPreviewViewController: UIViewController {
    
    weak var delegate: CapturedMediaPreviewDelegate?
    var mediaContainerView: UIView!
    var cancelButton: UIButton!
    var sendButton: SendButton!
    var media: CapturedMedia!
    private var cancelButtonImageView: UIImageView!
    
    func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func setUpCancelButton() {
        let cancelButtonImageViewFrame = CGRect(x: 16.0, y: 16.0, width: 24.0, height: 24.0)
        self.cancelButtonImageView = UIImageView(frame: cancelButtonImageViewFrame)
        self.cancelButtonImageView.image = #imageLiteral(resourceName: "cancel")
        self.view.addSubview(self.cancelButtonImageView)
        let cancelButtonFrame = CGRect(x: 0, y: 0, width: cancelButtonImageViewFrame.maxX + cancelButtonImageViewFrame.width/1.5, height: cancelButtonImageViewFrame.maxY + cancelButtonImageViewFrame.height/1.5)
        self.cancelButton = UIButton(frame: cancelButtonFrame)
        self.cancelButton.addTarget(self, action: #selector(self.dismissViewController), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    func setUpSendButton() {
        let sendFrameButtonHeight: CGFloat = 90/1.5
        let sendButtonFrame = CGRect(x: self.view.frame.maxX - sendFrameButtonHeight - 16, y: self.view.frame.maxY - sendFrameButtonHeight - 16, width: sendFrameButtonHeight, height: sendFrameButtonHeight)
        self.sendButton = SendButton(frame: sendButtonFrame)
        self.sendButton.addTarget(self, action: #selector(self.sendButtonTapped), for: .touchUpInside)
        self.view.addSubview(self.sendButton)
    }
    
    // TODO: - This is not working!
    func sendButtonTapped() {
        self.delegate?.capturedMediaPreviewViewController(self, userDidPressSendWithCapturedMedia: self.media)
        self.dismiss(completion: nil)
        self.containerSwipeNavigationController?.showEmbeddedView(position: .center)
    }
    
    private func dismiss(completion: (()->())?) {
        self.dismiss(animated: false, completion: completion)
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

