//
//  Asset.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/10.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Pring

@objcMembers
internal class Assets: Object {
    internal dynamic var code: String = ""
    internal dynamic var name: String?
    internal dynamic var admin: String?
    internal dynamic var user: String?
    internal dynamic var loss: Bool = false
    internal dynamic var discard: Bool = false
    internal dynamic var location: String?
    internal dynamic var quantity: Int = 0

    internal func updateWithSetParam(_ result: @escaping (Error?) -> Void) {
        print("Assets: updateWithSetParam")
        let dispatch = Dispatch()
        let label = "validate"

        dispatch.async(label: label) {
            Persons.isExist(value: self.user) { docId, error in
                if let error = error { print("Assets: \(error.localizedDescription)"); dispatch.leave(); return }
                print("Assets: person(user): \(docId ?? "not Found")")
                self.user = docId
                dispatch.leave()
            }
        }
        dispatch.async(label: label) {
            Persons.isExist(value: self.admin) { docId, error in
                if let error = error { print("Assets: \(error.localizedDescription)"); dispatch.leave(); return }
                print("Assets: person(admin): \(docId ?? "not Found")")
                self.admin = docId
                dispatch.leave()
            }
        }
        dispatch.async(label: label) {
            Locations.isExist(value: self.location) { docId, error in
                if let error = error { print("Assets: \(error.localizedDescription)"); dispatch.leave(); return }
                print("Assets: Locations: \(docId ?? "not Found")")
                self.location = docId
                dispatch.leave()
            }
        }
        dispatch.async(label: label) {
            AssetNames.isExist(value: self.name) { docId, error in
                if let error = error { print("Assets: \(error.localizedDescription)"); dispatch.leave(); return }
                print("Assets: AssetNames: \(docId ?? "not Found")")
                self.name = docId
                dispatch.leave()
            }
        }

        dispatch.notify(label: label) {
            print("Assets: notify")
            self.update { error in
                print("Assets: update complete")
                result(error)
            }
        }
    }
}
