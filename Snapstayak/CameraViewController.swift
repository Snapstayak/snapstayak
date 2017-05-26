//
//  CameraViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/24/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwiftyCam

protocol NewPostDelegate: class {
    func newPostWithCapturedMedia(_ capturedMedia: CapturedMedia)
}

class CameraViewController: SwiftyCamViewController {
    
    weak var postDelegate: NewPostDelegate?
    fileprivate var flipCameraButton: UIButton!
    fileprivate var cameraFlashButton: UIButton!
    fileprivate var cameraButton: RecordButton!
    let buttonWidthHeight: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cameraDelegate = self
        self.addButtons()
        self.maximumVideoDuration = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Camera button helpers
    
    private func addButtons() {
        // Camera button.
        self.cameraButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2 - (buttonWidthHeight/2), y: self.view.frame.maxY - (buttonWidthHeight) - 16, width: buttonWidthHeight, height: buttonWidthHeight))
        self.view.addSubview(self.cameraButton)
        self.cameraButton.delegate = self
        
        // Flip camera button.
        self.flipCameraButton = self.setUpFlipCameraButton(cameraButtonHeight: self.buttonWidthHeight)
        self.view.addSubview(flipCameraButton)
        
        // Camera flash button.
        self.cameraFlashButton = self.setUpFlashButton(cameraButtonHeight: self.buttonWidthHeight)
        self.view.addSubview(cameraFlashButton)
    }
    
    /// Set up the camera flash button.
    private func setUpFlashButton(cameraButtonHeight: CGFloat) -> UIButton {
        let cameraFlashButtonHeight = self.buttonWidthHeight / 2.0
        self.cameraFlashButton = UIButton(frame: CGRect(x: self.cameraButton.frame.minX - 2*cameraFlashButtonHeight, y: self.cameraButton.frame.origin.y + cameraFlashButtonHeight / 2.0, width: cameraFlashButtonHeight, height: cameraFlashButtonHeight))
        self.cameraFlashButton.addTarget(self, action: #selector(cameraFlashButtonTapped), for: .touchUpInside)
        self.cameraFlashButton.setImage((self.flashEnabled ? #imageLiteral(resourceName: "flash") : #imageLiteral(resourceName: "flashOutline")), for: .normal)
        
        return self.cameraFlashButton
    }
    
    /// Set up the flip camera button.
    private func setUpFlipCameraButton(cameraButtonHeight: CGFloat) -> UIButton {
        let flipCameraButtonHeight = self.buttonWidthHeight / 2.0
        self.flipCameraButton = UIButton(frame: CGRect(x: self.cameraButton.frame.maxX + flipCameraButtonHeight, y: self.cameraButton.frame.origin.y + flipCameraButtonHeight / 2.0, width: flipCameraButtonHeight, height: flipCameraButtonHeight))
        self.flipCameraButton.addTarget(self, action: #selector(reverseCamera), for: .touchUpInside)
        self.flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: .normal)
        
        return self.flipCameraButton
    }
    
    /// Helper function for selector to switch the camera.
    @objc private func reverseCamera() {
        self.switchCamera()
    }
    
    @objc private func cameraFlashButtonTapped() {
        self.flashEnabled = !self.flashEnabled
        self.cameraFlashButton.setImage((self.flashEnabled ? #imageLiteral(resourceName: "flash") : #imageLiteral(resourceName: "flashOutline")), for: .normal)
    }
}

extension CameraViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        guard let imagePreviewViewController = CapturedImagePreviewViewController(image: photo) else {
            fatalError("ImagePreviewViewController could not initialize")
        }
        imagePreviewViewController.delegate = self
        self.present(imagePreviewViewController, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        guard let videoPreviewViewController = CapturedVideoPreviewViewController(videoURL: url) else {
            fatalError("VideoPreviewViewController could not initialize!")
        }
        videoPreviewViewController.delegate = self
        self.present(videoPreviewViewController, animated: false, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.cameraFlashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.cameraFlashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
}

extension CameraViewController: CapturedMediaPreviewDelegate {
    func capturedMediaPreviewViewController(_ capturedMediaVC: CapturedMediaPreviewViewController, userDidPressSendWithCapturedMedia capturedMedia: CapturedMedia) {
        self.postDelegate?.newPostWithCapturedMedia(capturedMedia)
        self.containerSwipeNavigationController?.showEmbeddedView(position: .center)
    }
}
