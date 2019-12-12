//
// Swift usefull extensions
//

import Foundation
import UIKit

public extension UIApplication {
    static var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }

    static var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}
