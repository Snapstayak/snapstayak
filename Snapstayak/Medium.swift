//
//  Medium.swift
//  Snapstayak
//
//  Created by Nick McDonald on 5/10/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

enum MediumType: String {
    case video = "video"
    case image = "image"
}

class Medium: NSObject {
    var id: String!
    var type: MediumType!
    var url: URL!
    var expiration: Date!
    
    init(expiresAt: Date?) {
        id = UUID().uuidString
        url = URL(string: "https://tejen.net/sub/snapstayak/post.php?id=\(id)")
        expiration = expiresAt ?? Date.init(timeIntervalSinceNow: 3600 * 4) // by default, expires in four hours
    }
    
    convenience init?(photo: UIImage, expiresAt: Date?) {
        self.init(expiresAt: expiresAt)
        type = .image
        // TODO: begin uploading image asynchronously
    }
    
    convenience init?(video: Data, expiresAt: Date?) {
        self.init(expiresAt: expiresAt)
        type = .video
        // TODO: begin uploading video asynchronously
    }
    
    func Export() -> [String: String] {
        return [
            "id": id,
            "type": type.rawValue,
            "url": url!.absoluteString,
            "expiration": String(describing: expiration?.timeIntervalSince1970)
        ]
    }
}
