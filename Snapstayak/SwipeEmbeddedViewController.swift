//
//  SwipeEmbeddedViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/19/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import enum SwipeNavigationController.Position

class SwipeEmbeddedViewController: UIViewController {
    private var swipeType: Position!
    
    init(withType swipeType: Position) {
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
