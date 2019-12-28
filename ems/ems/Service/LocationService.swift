//
//  LocationService.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/25.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import PromiseKit

class LocationService {
    func convertProsess(value: String?) -> Promise<DocumentReference?> {
        guard let value = value else {
            return Promise<DocumentReference?>.value(nil)
        }

        return firstly {
            convert(value)
        }.then { docRef -> Promise<DocumentReference?> in
            guard let docRef = docRef else {
                return self.regist(value: value)
            }
            return Promise<DocumentReference?>.value(docRef)
        }
    }

    func convertProsess(docRef: DocumentReference?) -> Promise<String?> {
        guard let docRef = docRef else {
            return Promise<String?>.value(nil)
        }

        return convert(docRef)
    }

    private func convert(_ docRef: DocumentReference) -> Promise<String?> {
        Promise<String?> { seal in
            Locations.get(docRef.documentID) { model, _ in
                if let model = model {
                    seal.fulfill(model.location)
                } else {
                    seal.reject(DBStoreError.failed)
                }
            }
        }
    }

    private func convert(_ value: String) -> Promise<DocumentReference?> {
        Promise<DocumentReference?> { seal in
            Locations.existCheck(keyPath: \Locations.location, value: value).done { docRef in
                seal.fulfill(docRef)
            }.catch { error in
                if let error = error as? DBStoreError {
                    seal.reject(error)
                } else {
                    seal.reject(DBStoreError.failed)
                }
            }
        }
    }

    private func regist(value: String) -> Promise<DocumentReference?> {
        Promise<DocumentReference?> { seal in
            let model = Locations()
            model.location = value
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
