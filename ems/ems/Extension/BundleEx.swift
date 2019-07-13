//
//  BundleEx.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    var releaseVersionNumber: String {
        if let infoDict = Bundle.main.infoDictionary,
            let versionString = infoDict["CFBundleShortVersionString"] as? String {
            return versionString
        }
        return ""
    }

    var buildVersionNumber: String {
        if let infoDict = Bundle.main.infoDictionary,
            let versionString = infoDict["CFBundleVersion"] as? String {
            return versionString
        }
        return ""
    }

    var productName: String {
        if let infoDict = Bundle.main.infoDictionary,
            let productName = infoDict["CFBundleName"] as? String {
            return productName
        }
        return ""
    }

    var bundleIdName: String {
        if let bundleIdName = Bundle.main.bundleIdentifier {
            return bundleIdName
        }
        return ""
    }
}
