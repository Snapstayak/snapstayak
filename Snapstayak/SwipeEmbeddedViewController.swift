//
//  SwipeEmbeddedViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/19/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

enum SwipeEmbeddedViewControllerType {
    case center
    case bottom
    case left
    case right
    case top
}

class SwipeEmbeddedViewController: UIViewController {
    private var swipeType: SwipeEmbeddedViewControllerType!
    
    init(withType swipeType: SwipeEmbeddedViewControllerType) {
        super.init(nibName: nil, bundle: nil)
        self.swipeType = swipeType
        var backgroundColor: UIColor
        switch swipeType {
        case .center:
            backgroundColor = UIColor.white
        case .bottom:
            backgroundColor = UIColor.blue
        case .left:
            backgroundColor = UIColor.red
        case .right:
            backgroundColor = UIColor.brown
        case .top:
            backgroundColor = UIColor.cyan
        }
        self.view.backgroundColor = backgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
