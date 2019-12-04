//
//  CALayer.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

/// CALayerの拡張
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()

        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: frame.height, height: thickness)
            break

        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break

        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
            break

        case UIRectEdge.right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break

        default:
            break
        }

        border.backgroundColor = color.cgColor

        self.addSublayer(border)
    }
}
