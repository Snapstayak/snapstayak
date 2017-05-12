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

class CapturedVideoPreviewViewController: CapturedMediaPreviewViewController {
    
    private var videoURL: URL?
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
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
        self.setUpSendButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    
    // MARK: - Helper actions.
    
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
    
    override func sendButtonTapped() {
        guard let videoURL = self.videoURL else {
            return
        }
        self.postDelegate?.newVideoPostWithData(videoURL: videoURL)
        super.sendButtonTapped()
    }
}
