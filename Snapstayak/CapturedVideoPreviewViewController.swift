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
    
    init?(videoURL: URL) {
        super.init(nibName: nil, bundle: nil)
        do {
            self.media = try CapturedMedia(withVideoData: Data(contentsOf: videoURL))
        } catch {
            return nil
        }
        self.videoURL = videoURL
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

    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
