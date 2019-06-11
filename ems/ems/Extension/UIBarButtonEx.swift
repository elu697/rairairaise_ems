//
//  UIBarButtonEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/09.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

enum UIBarButtonItemPotition {
    case right
    case left
}

final class CustomBarItemButton: UIButton {

    @IBInspectable var top: CGFloat {
        get { return insets.top }
        set { insets.top = newValue }
    }
    @IBInspectable var left: CGFloat {
        get { return insets.left }
        set { insets.left = newValue }
    }
    @IBInspectable var bottom: CGFloat {
        get { return insets.bottom }
        set { insets.bottom = newValue }
    }
    @IBInspectable var right: CGFloat {
        get { return insets.right }
        set { insets.right = newValue }
    }

    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var rect = bounds
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom

        return rect.contains(point)
    }
}

extension UIBarButtonItem {

    ///
    /// - Parameters:
    ///   - image: Bar Button Icon Image
    ///   - position: NavigationBarの右か左か
    ///   - target: Tapした時に呼ばれるTarget
    ///   - action: Tapした時に呼ばれるAction
    /// - Returns: UIBarButtonItem
    static func createBarButton(image: UIImage?, position: UIBarButtonItemPotition, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = CustomBarItemButton()
        if #available(iOS 11, *) {
            button.frame = CGRect(x: 0, y: 0, width: 40, height: 28)
            switch position {
            case .left:
                button.insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 18)
            case .right:
                button.insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
            }
        } else {
            button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
            // UINavigationBarのButtonは余白が強制的に16入るので、そこからデザインに合わせて位置をずらす
            switch position {
            case .left:
                // 左にずらす
                button.insets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: -4)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            case .right:
                // 右にずらす
                button.insets = UIEdgeInsets(top: 10, left: -4, bottom: 10, right: 0)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            }
        }
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
