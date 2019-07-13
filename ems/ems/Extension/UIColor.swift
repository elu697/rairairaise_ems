//
//  UIColor.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

/// UIColorの拡張
public extension UIColor {
    /// グレーススケール
    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    /// RGB
    convenience init(red255: Int, green255: Int, blue255: Int, alpha: Double = 1.0) {
        let r = CGFloat(red255) / 255.0
        let g = CGFloat(green255) / 255.0
        let b = CGFloat(blue255) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    /// UIColorで指定された色のUIImageを返す
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
