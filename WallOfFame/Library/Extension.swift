//
//  Extension.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 27/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation


extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

