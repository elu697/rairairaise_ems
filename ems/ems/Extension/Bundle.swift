//
// Swift usefull extensions
//

import Foundation
import UIKit

extension Bundle {
    internal var releaseVersionNumber: String {
        if let infoDict = Bundle.main.infoDictionary,
            let versionString = infoDict["CFBundleShortVersionString"] as? String {
            return versionString
        }
        return ""
    }

    internal var buildVersionNumber: String {
        if let infoDict = Bundle.main.infoDictionary,
            let versionString = infoDict["CFBundleVersion"] as? String {
            return versionString
        }
        return ""
    }

    internal var productName: String {
        if let infoDict = Bundle.main.infoDictionary,
            let productName = infoDict["CFBundleName"] as? String {
            return productName
        }
        return ""
    }

    internal var bundleIdName: String {
        if let bundleIdName = Bundle.main.bundleIdentifier {
            return bundleIdName
        }
        return ""
    }
}
