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
                        self.setPersonField(docId: docId, value: value, field: field) {
                            dispatch.leave()
                        }
                    }
                case .locations:
                    Locations.isExist(keyPath: \Locations.location, value: self.location) { docId, error in
                        if error != nil { dispatch.leave(); return }
                        self.setLocationField(docId: docId) {
                            dispatch.leave()
                        }
                    }
                case .assetNames:
                    AssetNames.isExist(keyPath: \AssetNames.assetName, value: self.name) { docId, error in
                        if error != nil { dispatch.leave(); return }
                        self.setAssetNameField(docId: docId) {
                            dispatch.leave()
                        }
                    }
                }
            }
        }

        dispatch.notify(label: label, imp: complete)
    }
    
    private func setPersonField(docId: String?, value: String?, field: AnotherCollectionFields, _ complete: @escaping () -> Void) {
        guard let docId = docId else {
            createFieldCollection(collection: .persons, value: value) { docRef, _ in
                if field == .user { self.user = docRef?.documentID }
                if field == .admin { self.admin = docRef?.documentID }
                complete()
            }
            return
        }
        if field == .user { user = docId }
        if field == .admin { admin = docId }
        complete()
    }
    
    private func setLocationField(docId: String?, _ complete: @escaping () -> Void) {
        guard let docId = docId else {
            createFieldCollection(collection: .locations, value: location) { docRef, _ in
                self.location = docRef?.documentID
                complete()
            }
            return
        }
        location = docId
        complete()
    }
    
    private func setAssetNameField(docId: String?, _ complete: @escaping () -> Void) {
        guard let docId = docId else {
            createFieldCollection(collection: .assetNames, value: name) { docRef, _ in
                self.name = docRef?.documentID
                complete()
            }
            return
        }
        name = docId
        complete()
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
