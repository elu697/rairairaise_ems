//
//  PersonService.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/25.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import PromiseKit

class PersonService {
    func convertProsess(value: String?) -> Promise<DocumentReference> {
        guard let value = value else {
            return Promise<DocumentReference>(error: DBStoreError.inputFailed)
        }

        return firstly {
            convert(value: value)
        }.then { docRef in
            docRef.isEmpty ? self.regist(value: value) : Promise<DocumentReference>.value(docRef[0])
        }
    }

    private func convert(value: String) -> Promise<[DocumentReference]> {
        Promise<[DocumentReference]> { seal in
            Persons.existCheck(keyPath: \Persons.name, value: value).done { docRef in
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

    private func regist(value: String) -> Promise<DocumentReference> {
        Promise<DocumentReference> { seal in
            let person = Persons()
            person.name = value
            person.save { docRef, error in
                if let docRef = docRef {
                    seal.fulfill(docRef)
                } else {
                    seal.reject(error ?? DBStoreError.failed)
                }
            }
        }
    }
}
