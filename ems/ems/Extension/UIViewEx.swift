//
//  UIViewEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/09/23.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var roundRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    var viewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    var isHiddenWithAlpha: CGFloat {
        set {
            self.alpha = newValue
            self.isHidden = alpha.isEqual(to: 0.0)
            self.isUserInteractionEnabled = !alpha.isEqual(to: 0.0)
        }
        get {
            return self.alpha
        }
    }

    enum ShadowDirection {
        case top
        case bottom
    }

    //https://stackoverflow.com/questions/39624675/add-shadow-on-uiview-using-swift-3

    /// Soft Shadow
    func addShadow(direction: ShadowDirection,
                   radius: CGFloat = 2.5,
                   color: UIColor = UIColor.gray,
                   opacity: Float = 0.5) {

        switch direction {
        case .top:
            self.layer.shadowOffset = CGSize(width: 0.0, height: -1)
        case .bottom:
            self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        }

        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius

//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        let scale = true
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1

    }
}
