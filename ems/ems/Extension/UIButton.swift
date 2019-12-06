//
//  UIButton.swift
//  SalesIncome
//
//  Created by AmamiYou on 2018/10/30.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    internal func setBackgroundColor(
        color: UIColor, forState: UIControl.State
    ) {
        layer.masksToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

class UIButtonSwitch: UIButton {
    var onImage: UIImage = UIImage()
    var offImage: UIImage = UIImage()
    var isTapped: Bool = false {
        didSet {
            if self.isTapped {
                self.setImage(self.offImage, for: .normal)
            } else {
                self.setImage(self.onImage, for: .normal)
            }
        }
    }
    
    internal func setSwitchBtn(on: UIImage?, off: UIImage?) {
        guard let on = on, let off = off else { return }
        self.onImage = on
        self.offImage = off
        self.isTapped = false
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
    }
    
    @objc
    func tapButton(sender: UIButton) {
        if sender == self {
            isTapped = !isTapped
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
