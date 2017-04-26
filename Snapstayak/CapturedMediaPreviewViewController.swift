//
//  CapturedMediaPreviewViewController.swift
//  Snapstayak
//
//  Created by Nick McDonald on 4/26/17.
//  Copyright © 2017 Snapstayak. All rights reserved.
//

import UIKit

protocol CapturedMediaPreviewViewControllerDelegate: class {
    func capturedMediaPreviewViewControllerWillDismiss(_ capturedMediaVC: CapturedMediaPreviewViewController)
    func capturedMediaPreviewViewControllerDidDismiss(_ capturedMediaVC: CapturedMediaPreviewViewController)
}

protocol CapturedMediaPreviewViewController: NSObjectProtocol {
    weak var delegate: CapturedMediaPreviewViewControllerDelegate? { get set }
    var mediaContainerView: UIView! { get set }
    var cancelButton: UIButton! { get set }
    func dismissViewController()
}

extension CapturedMediaPreviewViewController where Self: UIViewController {
    func dismissViewController() {
        self.delegate?.capturedMediaPreviewViewControllerWillDismiss(self)
        self.dismiss(animated: true, completion: nil)
    }
}

