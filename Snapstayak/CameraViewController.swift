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
    
    fileprivate var currentState: CameraViewControllerState! {
        willSet(newState) {
            switch newState! {
            case .showingCapturedPhoto:
                print("Captured photo!")
            case .showingCapturedVideo:
                print("Captured video!")
            case .readyForMediaCapture:
                print("Ready!")
            }
        }
    }
    
    fileprivate var takenPhotoImageView: UIImageView!
    fileprivate var cameraButton: RecordButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.currentState = .readyForMediaCapture
        let buttonWidthHeight: CGFloat = 90
        self.cameraButton = RecordButton(frame: CGRect(x: self.view.frame.width / 2 - (buttonWidthHeight/2), y: self.view.frame.maxY - (buttonWidthHeight) - 16, width: buttonWidthHeight, height: buttonWidthHeight))
        self.view.addSubview(self.cameraButton)
        self.cameraButton.delegate = self
        self.cameraDelegate = self
        self.takenPhotoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.takenPhotoImageView.isHidden = true
        self.view.addSubview(self.takenPhotoImageView)
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
        self.cameraButton.isEnabled = false
        self.currentState = .showingCapturedPhoto
        self.takenPhotoImageView.image = photo
        self.takenPhotoImageView.isHidden = false
    }
}
