//
//  SwipeEmbeddedViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/25/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit
import SwipeNavigationController

/// Protocol that defines behavior for a view controller part of the SwipeNavigationController stack.
protocol SwipeEmbeddedViewController: class {
    var rootSwipeViewController: SwipeNavigationController? { get }
}

extension SwipeEmbeddedViewController {
    var rootSwipeViewController: SwipeNavigationController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.mainSwipeNavigationController
    }
}
