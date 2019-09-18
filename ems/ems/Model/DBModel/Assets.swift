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

    enum AnotherCollectionFields: CaseIterable {
        case name
        case admin
        case user
        case location

        enum Collection {
            case persons
            case locations
            case assetNames
        }

        var collection: Collection {
            switch self {
            case .user, .admin:
                return .persons

            case .name:
                return .assetNames

            case .location:
                return .locations
            }
        }
    }

    internal func updateWithSetParam(_ result: @escaping (Error?) -> Void) {
        print("Assets: updateWithSetParam")
        let dispatch = Dispatch()
        let label = "validate"

        AnotherCollectionFields.allCases.forEach { field in
            dispatch.async(label: label) {
                switch field.collection {
                case .persons:
                    let value = field == .user ? self.user : self.admin
                    Persons.isExist(keyPath: \Persons.name, value: value ?? "") { docId, _  in
                        if field == .user { self.user = docId }
                        if field == .admin { self.admin = docId }
                        dispatch.leave()
                    }

                case .locations:
                    Locations.isExist(keyPath: \Locations.location, value: self.location ?? "") { docId, _ in
                        self.location = docId
                        dispatch.leave()
                    }

                case .assetNames:
                    AssetNames.isExist(keyPath: \AssetNames.assetName, value: self.name ?? "") { docId, _ in
                        self.name = docId
                        dispatch.leave()
                    }
                }
            }
        }

        dispatch.notify(label: label) {
            self.update { error in
                result(error)
            }
        }
    }
}
