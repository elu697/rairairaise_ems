//
//  DBStore.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Pring
import FirebaseFirestore
import Foundation

internal class DBStore {
    static let share = DBStore()
    
    private init() {}
    
    private enum Field {
        case admin
        case user
        case name
        case location
    }
    
    func update(code: String, set: @escaping (Assets) -> Void, complete: @escaping (Error?) -> Void) {
        Assets.isExist(keyPath: \Assets.code, value: code) { docId, error in
            guard let docId = docId else { complete(error); return }
            let asset = Assets(id: docId, value: [:])
            asset.code = code
            set(asset)
            asset.updateWithSetParam { error in
                complete(error)
            }
        }
    }
    
    func set(_ set: @escaping (Assets) -> Void, _ complete: @escaping (Error?) -> Void) {
        let asset = Assets()
        set(asset)
        if asset.code == "" {
            return
        }
        
        Assets.isExist(keyPath: \Assets.code, value: asset.code) { docId, error in
            if docId == nil {
                if let error = error {
                    complete(error)
                } else {
                    asset.saveWithSetParam { error in
                        complete(error)
                    }
                }
            }
        }
    }
    
    func delete() {
        
    }
    
    func get(_ field: Assets.Field) {
        
    }
}
