//
//  UDManager.swift
//  ems
//
//  Created by 日座大輝 on 2019/09/20.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

class UDManager {
    enum UDkey: String {
        case sound = "ud_sound"
    }
    
    static func setUD(key: UDkey, value: Any) {
        let share = UserDefaults.standard
        share.set(value, forKey: key.rawValue)
        share.synchronize()
    }
    
    static func getUD(key: UDkey) -> Any {
        let share = UserDefaults.standard
        return share.object(forKey: key.rawValue) as Any
    }
}
