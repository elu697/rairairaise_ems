//
//  Constants.swift
//  ems
//
//  Created by El You on 2019/06/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Url {
        static let API_ENDPOINT = ""
        struct Wifi {
            static let GET_POINTS = ""
        }
    }

    struct Color {
        //        static let FIMAP_THEME = UIColor(red255: 135, green255: 192, blue255: 176)
        //        static let FIMAP_SECOND_THEME = UIColor(red255: 160, green255: 201, blue255: 159)
        //        static let NAVIGATION_BAR = UIColor(hex: 0x51B17E)
    }

    struct Image {
        static let back = R.image.icons8Back()
        static let deleate = R.image.icons8Delete_sign()
        static let menu = R.image.icons8Menu()
        static let user = R.image.icons8User()
        static let setting = R.image.icons8Settings()
        static let flashOn = R.image.icons8Flash_on()
        static let flashOff = R.image.icons8Flash_off()
        static let qr = R.image.icons8Qr_code()
        static let search = R.image.icons8Search()
    }

    struct Font {
        static let NOTO_SANS = "Noto Sans Chakma Regular"
        static let GUJA_SAN = "Gujarati Sangam MN"
    }

    struct Notification {
        static let SETTING_OPEN = NSNotification.Name("SETTING_OPEN")
        static let DISSMISS_KEYBOARD = NSNotification.Name("DISSMISS_KEYBOARD")
    }

    struct NotificationInfo {
        static let DATA = "DATA"
        static let WORD = "WORD"
    }
}
