//
//  Medium.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/10/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

enum MediumType {
    case Video
    case Image
}

class Medium: NSObject {
    var type: MediumType!
    var url: URL?
    var expiration: Date?
}
