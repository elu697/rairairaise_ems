//
//  AssetService.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/25.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import PromiseKit

class AssetService {
    private let field: Assets.Field

    var keyPath: PartialKeyPath<Assets> {
        switch field {
        case .code:
            return \Assets.code

        case .admin:
            return \Assets.admin

        case .user:
            return \Assets.user

        case .location:
            return \Assets.location

        case .name:
            return \Assets.name

        case .discard:
            return \Assets.discard

        case .loss:
            return \Assets.loss

        case .quantity:
            return \Assets.quantity
        }
    }

    init (field: Assets.Field = .code) {
        self.field = field
    }

    /// valueをdocIdに変換する関数
    /// - Parameter model: 変換前のModel
    func convert(model: Assets) -> Promise<Assets> {
        Promise<Assets> { seal in
            firstly {
                PersonService().convertProsess(value: model.admin["value"])
            }.then { docRef -> Promise<DocumentReference?> in
                model.admin["docId"] = docRef?.documentID
                return PersonService().convertProsess(value: model.user["value"])
            }.then { docRef -> Promise<DocumentReference?> in
                model.user["docId"] = docRef?.documentID
                return AssetNameService().convertProsess(value: model.name["value"])
            }.then { docRef -> Promise<DocumentReference?> in
                model.name["docId"] = docRef?.documentID
                return LocationService().convertProsess(value: model.location["value"])
            }.done { docRef in
                model.location["docId"] = docRef?.documentID
                seal.fulfill(model)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func `where`(value: Any) -> Promise<[QueryDocumentSnapshot]> {
        Promise<[QueryDocumentSnapshot]> { seal in
            Assets.where(keyPath, isEqualTo: value).get { snapShot, error in
                guard let snapShot = snapShot, error == nil else {
                    seal.reject(DBStoreError.failed)
                    return
                }
                seal.fulfill(snapShot.documents)
            }
        }
    }

    func getBy(value: Any) -> Promise<[Assets]> {
        Promise<[Assets]> { seal in
            self.where(value: value).then { snapShot -> Promise<[Assets]> in
                var prosess: [Promise<Assets>] = []
                snapShot.forEach { docRef in
                    prosess.append(self.get(docId: docRef.documentID))
                }
                return when(fulfilled: prosess)
            }.done { assets in
                seal.fulfill(assets)
            }.catch { _ in
                seal.reject(DBStoreError.failed)
            }
        }
    }

    private func get(docId: String) -> Promise<Assets> {
        Promise<Assets> { seal in
            Assets.get(docId) { model, _ in
                if let model = model {
                    seal.fulfill(model)
                } else {
                    seal.reject(DBStoreError.failed)
                }
            }
        }
    }
}
