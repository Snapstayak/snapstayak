//
//  CameraSessionCapturedPhotoImageView.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/23/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class CameraSessionCapturedPhotoImageView: UIImageView {
    
    override var image: UIImage? {
        willSet {
            self.isHidden = (newValue == nil) ? true : false
        }
    }
}
