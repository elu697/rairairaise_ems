//
// Swift usefull extensions
//

import Foundation
import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    var lines: [String] {
        var lines = [String]()
        self.enumerateLines { line, _ -> Void in
            lines.append(line)
        }
        return lines
    }
}
