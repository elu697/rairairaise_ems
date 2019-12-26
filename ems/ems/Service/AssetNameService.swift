//
//  AssetNameService.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/25.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import PromiseKit

class AssetNameService {
    func convertProsess(value: String?) -> Promise<DocumentReference?> {
        firstly {
            convert(value: value)
        }.then { docRef -> Promise<DocumentReference?> in
            guard let docRef = docRef else {
                return self.regist(value: value)
            }
            return Promise<DocumentReference?>.value(docRef)
        }
    }

    private func convert(value: String?) -> Promise<DocumentReference?> {
        Promise<DocumentReference?> { seal in
            AssetNames.existCheck(keyPath: \AssetNames.assetName, value: value).done { docRef in
                seal.fulfill(docRef.isEmpty ? nil : docRef[0])
            }.catch { error in
                if let error = error as? DBStoreError {
                    seal.reject(error)
                } else {
                    seal.reject(DBStoreError.failed)
                }
            }
        }
    }

    private func regist(value: String?) -> Promise<DocumentReference?> {
        Promise<DocumentReference?> { seal in
            let model = AssetNames()
            model.assetName = value
            model.save { docRef, error in
                if error != nil {
                    seal.reject(DBStoreError.failed)
                } else {
                    seal.fulfill(docRef)
                }
            }
        }
    }
}
