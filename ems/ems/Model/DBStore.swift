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
import PromiseKit

internal class DBStore {
    static let shared = DBStore()

    private init() {}

    func update(_ input: Asset) -> Promise<Void> {
        guard input.validated else {
            return Promise<Void>(error: DBStoreError.inputFailed)
        }

        return Promise<Void> { seal in
            firstly {
                Assets.existCheck(keyPath: \Assets.code, value: input.code)
            }.then { _ -> Promise<[Assets]> in
                AssetService(field: .code).getBy(value: input.code as Any)
            }.then { models -> Promise<Assets> in
                guard let model = models.first else {
                    return Promise<Assets>(error: DBStoreError.notFound)
                }
                model.set(input.value)
                return AssetService().convert(model: model)
            }.then { asset -> Promise<Void> in
                asset.update()
            }.done { _ in
                seal.fulfill_()
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func regist(_ input: Asset) -> Promise<Void> {
        guard input.validated else {
            return Promise<Void>(error: DBStoreError.inputFailed)
        }

        return Promise<Void> { seal in
            let model = Assets.copy(model: input)
            firstly {
                Assets.existCheck(keyPath: \Assets.code, value: model.code)
            }.then { _ -> Promise<Assets> in
               AssetService().convert(model: model)
            }.then { converted -> Promise<[DocumentReference]> in
                converted.save()
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
                guard let docRef = docRef else {
                    return Promise<Void>(error: DBStoreError.failed)
                }
                return Assets(id: docRef.documentID).delete()
            }.done {
                seal.fulfill_()
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func search(field: Assets.Field, value: Any) -> Promise<[Asset]> {
        Promise<[Asset]> { seal in
            firstly {
                AssetService(field: field).getBy(value: value)
            }.done { models in
                seal.fulfill(models.map { Asset(value: $0.dictionary) })
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
