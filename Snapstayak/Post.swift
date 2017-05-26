//
//  Post.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/10/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import CoreLocation

class Post: NSObject {
    var id: String?
    var author: User?
    var media: [Medium]?
    var location: CLLocation!
}
