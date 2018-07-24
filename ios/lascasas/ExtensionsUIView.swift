//
//  ExtensionsUIView.swift
//  carlo_monteiro_ios_
//
//  Created by pepdevils  on 03/10/16.
//  Copyright © 2016 pepdevils. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 5.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 10.0)
        rotateAnimation.duration = duration
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
