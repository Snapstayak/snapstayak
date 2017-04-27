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
    fileprivate var flashButton: UIButton!
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
        
        // Reverse camera button.
        let reverseCameraHeight = self.buttonWidthHeight / 2.0
        let reverseCameraButton = UIButton(frame: CGRect(x: self.cameraButton.frame.maxX + reverseCameraHeight, y: self.cameraButton.frame.origin.y + reverseCameraHeight / 2.0, width: reverseCameraHeight, height: reverseCameraHeight))
        reverseCameraButton.addTarget(self, action: #selector(reverseCamera), for: .touchUpInside)
        reverseCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: .normal)
        self.view.addSubview(reverseCameraButton)
        
        
    }
    
    @objc private func reverseCamera() {
        self.switchCamera()
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
//            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
//            self.flashButton.alpha = 1.0
//            self.flipCameraButton.alpha = 1.0
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
