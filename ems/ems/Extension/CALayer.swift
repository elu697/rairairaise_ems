//
// Swift usefull extensions
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

    internal func addUnderline() {
        self.backgroundColor = UIColor.white.cgColor
        self.masksToBounds = false
        self.shadowColor = UIColor.gray.cgColor
        self.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.shadowOpacity = 1.0
        self.shadowRadius = 0.0
    }
}
