//
//  AppDataManager.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

class AppDataManager {
    static let shared = AppDataManager()
    private init() {}
    
    private var data: [String: [String: Any]] = [:]
    
    func set(key: String, value: Any, absolutePath: String = #file) {
        if data[absolutePath] == nil {
            data[absolutePath] = [:]
        }
        data[absolutePath]?[key] = value
    }
    
    func get(key: String, absolutePath: String = #file) -> Any? {
        return data[absolutePath]?[key]
    }
}
