//
//  DBStore.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import PromiseKit
import Pring

internal class DBStore {
    internal static let share = DBStore()

    private init() {}

    internal func update(code: String, set: @escaping (Assets) -> Void, complete: @escaping (Error?) -> Void) {
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
    
    func regist(_ input: @escaping (Assets) -> Void) -> Promise<Void> {
        let model = Assets()
        input(model)
        
        guard !model.code.isEmpty else {
            return Promise<Void>.init(error: DBStoreError.inputFailed)
        }
        
        return Promise<Void> { seal in
            firstly {
                Assets.existCheck(keyPath: \Assets.code, value: model.code)
            }.then { docRef -> Promise<Assets> in
                return docRef.isEmpty ? AssetService().convert(model: model) : Promise<Assets>.init(error: DBStoreError.existCode)
            }.then { converted -> Promise<[DocumentReference]> in
                return converted.save()
            }.done { _ in
                seal.fulfill_()
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    func delete(code: String) -> Promise<Void> {
        Promise<Void> { seal in
            firstly {
                Assets.existCheck(keyPath: \Assets.code, value: code)
            }.then { docRef -> Promise<Void> in
                Assets(id: docRef[0].documentID).delete()
            }.done {
                seal.fulfill_()
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    internal func search(field: Assets.Field, value: Any, limit: Int? = nil, _ complete: @escaping ([Assets]?, Error?) -> Void) {
        let dispatch = Dispatch(label: "search")
        var item: Any?
        switch field.type {
        case .persons:
            dispatch.async {
                guard let value = value as? String else { return }
                Persons.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete([], error); return }
                    item = docRef
                    dispatch.leave()
                }
            }

        case .locations:
            dispatch.async {
                guard let value = value as? String else { return }
                Locations.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete([], error); return }
                    item = docRef
                    dispatch.leave()
                }
            }

        case .assetNames:
            dispatch.async {
                guard let value = value as? String else { return }
                AssetNames.getDocumentId(value: value) { docRef, error in
                    guard let docRef = docRef else { dispatch.leave(); complete([], error); return }
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
            if let limit = limit {
                query.limit(to: limit).get { snapShot, error in
                    guard let snapShot = snapShot else {
                        complete(nil, error)
                        return
                    }
                    print("DBStore: \(snapShot.documents.count)")
                    Assets.getAssets(snapShots: snapShot.documents) { assets in
                        complete(assets, nil)
                    }
                }
            } else {
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
