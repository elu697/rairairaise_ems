//
//  UDManager.swift
//  ems
//
//  Created by 日座大輝 on 2019/09/20.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

internal class UDManager {
    internal enum UDkey: String {
        case sound = "ud_sound"
    }
    
    internal static func setUD(key: UDkey, value: Any) {
        let share = UserDefaults.standard
        share.set(value, forKey: key.rawValue)
        share.synchronize()
    }
    
    internal static func getUD(key: UDkey) -> Any {
        let share = UserDefaults.standard
        return share.object(forKey: key.rawValue) as Any
    }
}
