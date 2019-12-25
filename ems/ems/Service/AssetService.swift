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
    func convert(model: Assets) -> Promise<Assets> {
        Promise<Assets> { seal in
            let buf = Assets.copy(model: model)
            firstly {
                PersonService().convertProsess(value: model.admin)
            }.then { docRef -> Promise<DocumentReference> in
                buf.admin = docRef.documentID
                return PersonService().convertProsess(value: model.user)
            }.then { docRef -> Promise<DocumentReference> in
                buf.user = docRef.documentID
                return AssetNameService().convertProsess(value: model.name)
            }.then { docRef -> Promise<DocumentReference> in
                buf.name = docRef.documentID
                return LocationService().convertProsess(value: model.location)
            }.done { docRef in
                buf.location = docRef.documentID
                seal.fulfill(buf)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
