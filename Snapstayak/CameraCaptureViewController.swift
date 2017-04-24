//
//  CameraCaptureViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/23/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: UIViewController {

    @IBOutlet weak var cameraSessionPreviewView: UIView!
    @IBOutlet weak var takenPhotoImageView: UIImageView!
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    private var captureDevice: AVCaptureDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.takenPhotoImageView.isHidden = true
        self.prepareCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beginSession()
    }
    
    
    // MARK: - Camera Preview.
    
    private func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            self.captureDevice = availableDevices.first
        }
    }
    
    private func beginSession() {
        // Try to add our input device to the capture session.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if let cameraSessionPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) {
            self.cameraPreviewLayer = cameraSessionPreviewLayer
            self.cameraSessionPreviewView.layer.addSublayer(self.cameraPreviewLayer)
            self.cameraPreviewLayer.frame = self.view.layer.frame
            self.cameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if self.captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            self.captureSession.commitConfiguration()
        }
    }
}
