//
//  DBStore.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Pring

internal class DBStore {
    static let share = DBStore()

    private init() {}

    func update(code: String, set: @escaping (Assets) -> Void, complete: @escaping (Error?) -> Void) {
        Assets.isExist(keyPath: \Assets.code, value: code) { docRef, error in
            guard let docRef = docRef else { complete(error); return }
            let asset = Assets(id: docRef.documentID, value: [:])
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
                    return
                }
                asset.saveWithSetParam { error in
                    complete(error)
                }
            }
        }
    }

    func delete() {
    }

    func search(field: Assets.Field, value: Any, _ complete: @escaping ([Assets]?, Error?) -> Void) {
        let dispatch = Dispatch(label: "search")
        var item: Any?
        switch field.type {
        case .persons:
            dispatch.async {
                guard let value = value as? String else { return }
                Persons.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete(nil, error); return }
                    item = docRef
                    dispatch.leave()
                }
            }

        case .locations:
            dispatch.async {
                guard let value = value as? String else { return }
                Locations.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete(nil, error); return }
                    item = docRef
                    dispatch.leave()
                }
            }

        case .assetNames:
            dispatch.async {
                guard let value = value as? String else { return }
                AssetNames.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete(nil, error); return }
                    item = docRef
                    dispatch.leave()
                }
            }

        default:
            dispatch.async {
                item = value
                dispatch.leave()
            }
        }

        dispatch.notify {
            guard let searchItem = item, let query = self.classificationQuery(field: field, value: searchItem) else { return }
            query.get { snapShot, error in
                guard let snapShot = snapShot else {
                    complete(nil, error)
                    return
                }
                print("DBStore: \(snapShot.documents.count)")
                Assets.getAssets(snapShots: snapShot.documents) { assets in
                    complete(assets, nil)
                }
            }
        }
    }

    private func classificationQuery(field: Assets.Field, value: Any) -> DataSource<Assets>.Query? {
        var query: DataSource<Assets>.Query
        switch field {
        case .user:
            guard let docRef = value as? QueryDocumentSnapshot else { return nil }
            query = Assets.where(\Assets.user, isEqualTo: docRef.documentID)

        case .admin:
            guard let docRef = value as? QueryDocumentSnapshot else { return  nil }
            query = Assets.where(\Assets.admin, isEqualTo: docRef.documentID)

        case .location:
            guard let docRef = value as? QueryDocumentSnapshot else { return nil }
            query = Assets.where(\Assets.location, isEqualTo: docRef.documentID)

        case .name:
            guard let docRef = value as? QueryDocumentSnapshot else { return nil }
            query = Assets.where(\Assets.name, isEqualTo: docRef.documentID)

        case .code:
            query = Assets.where(\Assets.code, isEqualTo: value)

        case .discard:
            query = Assets.where(\Assets.discard, isEqualTo: value)

        case .loss:
            query = Assets.where(\Assets.loss, isEqualTo: value)

        case .quantity:
            query = Assets.where(\Assets.quantity, isEqualTo: value)
        }

        return query
    }
}
