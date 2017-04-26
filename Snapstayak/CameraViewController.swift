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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let buttonWidthHeight: CGFloat = 90
        self.cameraButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2 - (buttonWidthHeight/2), y: self.view.frame.maxY - (buttonWidthHeight) - 16, width: buttonWidthHeight, height: buttonWidthHeight))
        self.view.addSubview(self.cameraButton)
        self.cameraButton.delegate = self
        self.cameraDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CameraViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let imagePreviewViewController = CapturedImagePreviewViewController()
        imagePreviewViewController.image = photo
        imagePreviewViewController.delegate = self
        self.present(imagePreviewViewController, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        self.cameraButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        //
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
