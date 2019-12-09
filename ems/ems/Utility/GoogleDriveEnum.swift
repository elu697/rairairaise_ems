//
//  GoogleDriveEnum.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

enum GoogleDriveStatus {
    case signin
    case signout
}

enum GoogleDriveNotify: String {
    case name
    
    var value: String {
        switch self {
        case .name:
            return "ToggleAuthUINotification"
        }
    }
}
