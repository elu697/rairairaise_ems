//
//  UIDeviceEx.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

/// screen type
extension UIDevice {

    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPad
        case unknown
    }

    static var screenType: ScreenType {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return .iPhones_4_4S
            case 1136:
                return .iPhones_5_5s_5c_SE
            case 1334:
                return .iPhones_6_6s_7_8
            case 1920, 2208:
                return .iPhones_6Plus_6sPlus_7Plus_8Plus
            case 2436:
                return .iPhoneX
            default:
                return .unknown
            }
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .unknown
        }
    }
}
