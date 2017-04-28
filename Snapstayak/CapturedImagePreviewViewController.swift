//
//  CapturedImagePreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class CapturedImagePreviewViewController: CapturedMediaPreviewViewController {
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

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
    
    func onDismissButtonTapped() {
        print("Button tapped!")
        self.dismissViewController()
    }
}
