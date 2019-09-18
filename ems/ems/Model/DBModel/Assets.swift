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

    private enum AnotherCollectionFields: CaseIterable {
        case name
        case admin
        case user
        case location

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

    private enum Collection {
        case persons
        case locations
        case assetNames
    }

    internal enum Field {
        case code
        case name
        case admin
        case user
        case loss
        case discard
        case location
        case quantity
    }

    internal func updateWithSetParam(_ result: @escaping (Error?) -> Void) {
        print("Assets: updateWithSetParam")
        setParam {
            self.update { error in
                result(error)
            }
        }
    }

    internal func saveWithSetParam(_ result: @escaping (Error?) -> Void) {
        setParam {
            self.save { _, error in
                result(error)
            }
        }
    }

    private func setParam(_ complete: @escaping () -> Void) {
        let dispatch = Dispatch()
        let label = "validate"

        AnotherCollectionFields.allCases.forEach { field in
            dispatch.async(label: label) {
                switch field.collection {
                case .persons:
                    let value = field == .user ? self.user : self.admin
                    Persons.isExist(keyPath: \Persons.name, value: value) { docId, error in
                        if error != nil { dispatch.leave(); return }
                        guard let docId = docId else {
                            self.createFieldCollection(collection: .persons, value: value) { docRef, _ in
                                if field == .user { self.user = docRef?.documentID }
                                if field == .admin { self.admin = docRef?.documentID }
                                dispatch.leave()
                            }
                            return
                        }
                        if field == .user { self.user = docId }
                        if field == .admin { self.admin = docId }
                        dispatch.leave()
                    }

                case .locations:
                    Locations.isExist(keyPath: \Locations.location, value: self.location) { docId, error in
                        if error != nil { dispatch.leave(); return }
                        guard let docId = docId else {
                            self.createFieldCollection(collection: .locations, value: self.location) { docRef, _ in
                                self.location = docRef?.documentID
                                dispatch.leave()
                            }
                            return
                        }
                        self.location = docId
                        dispatch.leave()
                    }

                case .assetNames:
                    AssetNames.isExist(keyPath: \AssetNames.assetName, value: self.name) { docId, error in
                        if error != nil { dispatch.leave(); return }
                        guard let docId = docId else {
                            self.createFieldCollection(collection: .assetNames, value: self.name) { docRef, _ in
                                self.name = docRef?.documentID
                                dispatch.leave()
                            }
                            return
                        }
                        self.name = docId
                        dispatch.leave()
                    }
                }
            }
        }

        dispatch.notify(label: label, imp: complete)
    }

    private func createFieldCollection(collection: Collection, value: String?, _ complete: @escaping (DocumentReference?, Error?) -> Void) {
        switch collection {
        case .persons:
            let person = Persons()
            person.name = value
            person.save(complete)

        case .locations:
            let location = Locations()
            location.location = value
            location.save(complete)

        case .assetNames:
            let assetName = AssetNames()
            assetName.assetName = value
            assetName.save(complete)
        }
    }
}
