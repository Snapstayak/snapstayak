//
//  CapturedVideoPreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CapturedVideoPreviewViewController: UIViewController, CapturedMediaPreviewViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var cancelButton: UIButton!
    var mediaContainerView: UIView!
    weak var delegate: CapturedMediaPreviewViewControllerDelegate?

    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        guard let videoURL = self.videoURL else {
            fatalError("No URL.")
        }
        
        self.player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        self.setUpCancelButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    
    // MARK: - Helper actions.
    
    func setUpCancelButton() {
        self.cancelButton = UIButton(frame: CGRect(x: 16.0, y: 16.0, width: 24.0, height: 24.0))
        self.cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(onDismissButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func onDismissButtonTapped() {
        print("Button tapped!")
        self.dismissViewController()
    }

    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
