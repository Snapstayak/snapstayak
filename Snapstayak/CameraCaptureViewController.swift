//
//  CameraCaptureViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/21/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import AVFoundation

class CameraCaptureViewController: SwipeEmbeddedViewController {
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.capturePreviewLayer?.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard self.captureSession == nil else {
            return
        }
        
        self.captureSession = AVCaptureSession()
        self.captureSession?.sessionPreset = AVCaptureSessionPreset1920x1080
        
        let rearCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: rearCamera)
        } catch {
            fatalError()
        }
        if (captureSession?.canAddInput(input))! {
            captureSession?.addInput(input!)
            self.stillImageOutput = AVCapturePhotoOutput()
            // TODO: might need to fix this ^
            if (captureSession?.canAddOutput(self.stillImageOutput))! {
                captureSession?.addOutput(self.stillImageOutput)
                self.capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                self.capturePreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.capturePreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                self.view.layer.addSublayer(self.capturePreviewLayer!)
                self.captureSession?.startRunning()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
