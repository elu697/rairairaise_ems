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

/*extension DBStore {
    func setDocumentRef(asset: Assets, _ result: @escaping () -> Void) {
        let dispatch = Dispatch()
        let label = "docRef"
        
        dispatch.async(label: label) { [weak self] in
            guard let self = self else { return }
            self.convertDocumentRef(type: .admin, value: asset.admin) {
                docRef in asset.admin = docRef?.documentID
                dispatch.leave()
            }
        }
        
        
        self.convertDocumentRef(type: .user, value: asset.user) { docRef in asset.user = docRef?.documentID }
        self.convertDocumentRef(type: .location, value: asset.location) { docRef in asset.location = docRef?.documentID }
        self.convertDocumentRef(type: .name, value: asset.name) { docRef in asset.name = docRef?.documentID }
    }
    
    func convertDocumentRef(type: Field, value: String?, _ result: @escaping (DocumentReference?) -> Void) {
        guard let value = value else {return}
        
        isExist(type: type, value: value) { isEmpty in
            guard !isEmpty else { return }
            
            var object: Object
            switch type {
            case .user, .admin:
                let person = Persons()
                person.name = value
                object = person
            case .location:
                let location = Locations()
                location.location = value
                object = location
            case .name:
                let assetName = AssetNames()
                assetName.assetName = value
                object = assetName
            }
            
            object.save { docRef, _ in
                result(docRef)
            }
        }
    }
    
    func isExist(type: Field, value: String, _ result: @escaping (Bool) -> Void) {
        let result: (Bool) -> Void
        switch type {
        case .user, .admin:
            let person = Persons()
            person.name = value
            person.isExist(result)
        case .name:
            let name = AssetNames()
            
        }
    }
}*/
