//
//  CameraViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/24/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwiftyCam

enum CameraViewControllerState {
    case readyForMediaCapture
    case showingCapturedPhoto
    case showingCapturedVideo
}

class CameraViewController: SwiftyCamViewController, SwipeEmbeddedViewController {
    
    fileprivate var flipCameraButton: UIButton!
    fileprivate var cameraFlashButton: UIButton!
    fileprivate var cameraButton: RecordButton!
    
    let buttonWidthHeight: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cameraDelegate = self
        self.addButtons()
        self.maximumVideoDuration = 10.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addButtons() {
        // Camera button.
        self.cameraButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2 - (buttonWidthHeight/2), y: self.view.frame.maxY - (buttonWidthHeight) - 16, width: buttonWidthHeight, height: buttonWidthHeight))
        self.view.addSubview(self.cameraButton)
        self.cameraButton.delegate = self
        
        // Flip camera button.
        let flipCameraButtonHeight = self.buttonWidthHeight / 2.0
        self.flipCameraButton = UIButton(frame: CGRect(x: self.cameraButton.frame.maxX + flipCameraButtonHeight, y: self.cameraButton.frame.origin.y + flipCameraButtonHeight / 2.0, width: flipCameraButtonHeight, height: flipCameraButtonHeight))
        self.flipCameraButton.addTarget(self, action: #selector(reverseCamera), for: .touchUpInside)
        self.flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: .normal)
        self.view.addSubview(flipCameraButton)
        
        // Camera flash button.
        let cameraFlashButtonHeight = flipCameraButtonHeight
        self.cameraFlashButton = UIButton(frame: CGRect(x: self.cameraButton.frame.minX - 2*cameraFlashButtonHeight, y: self.cameraButton.frame.origin.y + cameraFlashButtonHeight / 2.0, width: cameraFlashButtonHeight, height: cameraFlashButtonHeight))
        self.cameraFlashButton.addTarget(self, action: #selector(cameraFlashButtonTapped), for: .touchUpInside)
        self.cameraFlashButton.setImage((self.flashEnabled ? #imageLiteral(resourceName: "flash") : #imageLiteral(resourceName: "flashOutline")), for: .normal)
        self.view.addSubview(cameraFlashButton)
    }
    
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
        let imagePreviewViewController = CapturedImagePreviewViewController(image: photo)
        imagePreviewViewController.delegate = self
        self.present(imagePreviewViewController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let videoPreviewViewController = CapturedVideoPreviewViewController(videoURL: url)
        videoPreviewViewController.delegate = self
        self.present(videoPreviewViewController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
}

extension CameraViewController: CapturedMediaPreviewViewControllerDelegate {
    func capturedMediaPreviewViewControllerDidDismiss(_ capturedMediaVC: CapturedMediaPreviewViewController) {
        //
    }
    
    func capturedMediaPreviewViewControllerWillDismiss(_ capturedMediaVC: CapturedMediaPreviewViewController) {
        print("Will dismiss!")
    }
}
