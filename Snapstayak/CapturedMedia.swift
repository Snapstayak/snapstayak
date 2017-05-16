//
//  CapturedMedia.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/14/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

class CapturedMedia: NSObject {
    var type: MediumType!
    var data: Data?
    
    init(withImage image: UIImage) {
        self.type = .image
        self.data = UIImagePNGRepresentation(image)
    }
    
    init(withVideoData videoData: Data) {
        self.type = .video
        self.data = videoData
    }
}
