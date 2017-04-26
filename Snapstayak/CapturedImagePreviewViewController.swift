//
//  CapturedImagePreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class CapturedImagePreviewViewController: UIViewController, CapturedMediaPreviewViewController {
    
    weak var delegate: CapturedMediaPreviewViewControllerDelegate?
    var mediaContainerView: UIView!
    var cancelButton: UIButton!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mediaContainerView = UIImageView()
        self.mediaContainerView.frame = self.view.frame
        self.view.addSubview(mediaContainerView)
        guard let image = self.image else {
            fatalError("No image!")
        }
        (self.mediaContainerView as? UIImageView)?.image = image
        self.setUpCancelButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Helper actions.
    
    func setUpCancelButton() {
        self.cancelButton = UIButton(frame: CGRect(x: 16.0, y: 16.0, width: 24.0, height: 24.0))
        self.cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(onDismissButtonTapped), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    func onDismissButtonTapped() {
        print("Button tapped!")
        self.dismissViewController()
    }
}
