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
    @IBOutlet weak var takenPhotoImageView: CameraSessionCapturedPhotoImageView!
    
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    private let captureSession = AVCaptureSession()
    private var captureDevice: AVCaptureDevice!
    fileprivate var shouldTakePhoto: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.takenPhotoImageView.isHidden = true
        self.cameraSessionPreviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTouchedView)))
        self.takenPhotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prepareCamera)))
        self.takenPhotoImageView.isUserInteractionEnabled = true
        self.shouldTakePhoto = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prepareCamera()
    }
    
    
    // MARK: - Camera Preview logisitics.
    
    func userTouchedView() {
        self.shouldTakePhoto = true
    }
    
    @objc private func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            self.captureDevice = availableDevices.first
            self.beginCaptureSession()
        }
    }
    
    private func getCameraSessionPreviewLayer() -> AVCaptureVideoPreviewLayer {
        guard let previewLayer = self.cameraPreviewLayer else {
            return AVCaptureVideoPreviewLayer(session: self.captureSession)
        }
        return previewLayer
    }
    
    private func frameCameraSessionPreviewLayer(_ previewLayer: AVCaptureVideoPreviewLayer) {
        guard self.cameraPreviewLayer == nil else {
            return
        }
        self.cameraPreviewLayer = previewLayer
        self.cameraSessionPreviewView.layer.addSublayer(self.cameraPreviewLayer)
        self.cameraPreviewLayer.frame = self.view.layer.frame
        self.cameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill  // Video gravity to fill up the entire frame.
    }
    
    private func beginCaptureSession() {
        self.takenPhotoImageView.image = nil
        // Try to add our input device to the capture session.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: self.captureDevice)
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Get an instance of AVCaptureVideoPreviewLayer for previewing the camera.
        let previewLayer = self.getCameraSessionPreviewLayer()
        self.frameCameraSessionPreviewLayer(previewLayer)
        
        self.captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if self.captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        self.captureSession.commitConfiguration()
        
        let outputQueue = DispatchQueue(label: "com.snapstayak.snapstayak.captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: outputQueue)
    }
    
    fileprivate func stopCaptureSession() {
        self.captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }
}

/// Extension for capturing the AVCaptureVideoDataOutputSampleBuffer.
extension CameraCaptureViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard self.shouldTakePhoto == true else {
            return
        }
        self.shouldTakePhoto = false
        guard let image = self.getImageFromSampleBuffer(sampleBuffer) else {
            return
        }
        DispatchQueue.main.async {
            self.takenPhotoImageView.image = image
            self.stopCaptureSession()
        }
    }
    
    private func getImageFromSampleBuffer(_ buffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        if let image = context.createCGImage(ciImage, from: imageRect) {
            return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
        }
        return nil
    }
}

