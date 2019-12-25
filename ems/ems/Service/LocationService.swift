//
//  LocationService.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/25.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import PromiseKit
import FirebaseFirestore

class LocationService {
    func convertProsess(value: Any) -> Promise<DocumentReference> {
        guard let value = value as? String else {
            return Promise<DocumentReference>.init(error: DBStoreError.inputFailed)
        }
        
        return firstly {
            convert(value: value)
        }.then { docRef in
            return docRef.isEmpty ? self.regist(value: value) : Promise<DocumentReference>.value(docRef[0])
        }
    }
    
    private func convert(value: String) -> Promise<[DocumentReference]> {
        Promise<[DocumentReference]> { seal in
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
    
    private func regist(value: String) -> Promise<DocumentReference> {
        Promise<DocumentReference> { seal in
            let location = Locations()
            location.location = value
            location.save { docRef, error in
                if let docRef = docRef {
                    seal.fulfill(docRef)
                } else {
                    seal.reject(error ?? DBStoreError.failed)
                }
            }
        }
    }
}
