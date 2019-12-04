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

    internal enum Collection {
        case persons
        case locations
        case assetNames
        case assets
    }

    internal enum Field: String, CaseIterable {
        case code
        case name
        case admin
        case user
        case loss
        case discard
        case location
        case quantity

        internal var name: String {
            switch self {
            case .code:
                return "資産コード"
            case .name:
                return "資産名"
            case .admin:
                return " 管理者"
            case .user:
                return "使用者"
            case .loss:
                return "紛失"
            case .discard:
                return "廃棄"
            case .location:
                return "管理場所"
            case .quantity:
                return "数量"
            }
        }

        var type: Collection {
            switch self {
            case .admin, .user:
                return .persons

            case .location:
                return .locations

            case .name:
                return .assetNames

            default:
                return .assets
            }
        }
    }

    private func getValue(field: Field) -> String? {
        switch field {
        case .user:
            return user

        case .admin:
            return admin

        case .location:
            return location

        case .name:
            return name
        default: return nil
        }
    }

    internal func updateWithSetParam(_ result: @escaping (Error?) -> Void) {
        print("Assets: updateWithSetParam")
        convertValue { data in
            self.setValue(data: data)
            self.update { error in
                result(error)
            }
        }
    }

    internal func saveWithSetParam(_ result: @escaping (Error?) -> Void) {
        convertValue { data in
            self.setValue(data: data)
            self.save { _, error in
                result(error)
            }
        }
    }

    internal static func getAssets(snapShots: [QueryDocumentSnapshot], _ complete: @escaping ([Assets]) -> Void) {
        var assets: [Assets] = []
        guard !snapShots.isEmpty else {
            complete(assets)
            return
        }
        let dispatch = Dispatch(label: "assets")

        snapShots.forEach { docRef in
            dispatch.async {
                Assets.get(docRef.documentID) { asset, _ in
                    guard let asset = asset else { dispatch.leave(); return }
                    asset.setValue {
                        assets.append(asset)
                        dispatch.leave()
                    }
                }
            }
        }

        dispatch.notify {
            complete(assets)
        }
    }
}

// MARK: - private function
extension Assets {
    private func convertValue(_ complete: @escaping ([Field: DocumentReference?]) -> Void) {
        let dispatch = Dispatch(label: "convert")

        var data: [Field: DocumentReference?] = [:]
        Field.allCases.forEach { field in
            dispatch.async {
                switch field.type {
                case .persons:
                    Persons.isExist(keyPath: \Persons.name, value: self.getValue(field: field)) { docRef, _ in
                        if let docRef = docRef {
                            data[field] = docRef
                            dispatch.leave()
                        } else {
                            let person = Persons()
                            person.name = self.getValue(field: field)
                            person.save { docRef, _ in
                                data[field] = docRef
                                dispatch.leave()
                            }
                        }
                    }

                case .assetNames:
                    AssetNames.isExist(keyPath: \AssetNames.assetName, value: self.getValue(field: field)) { docRef, _ in
                        if let docRef = docRef {
                            data[field] = docRef
                            dispatch.leave()
                        } else {
                            let assetName = AssetNames()
                            assetName.assetName = self.getValue(field: field)
                            assetName.save { docRef, _ in
                                data[field] = docRef
                                dispatch.leave()
                            }
                        }
                    }

                case .locations:
                    Locations.isExist(keyPath: \Locations.location, value: self.getValue(field: field)) { docRef, _ in
                        if let docRef = docRef {
                            data[field] = docRef
                            dispatch.leave()
                        } else {
                            let location = Locations()
                            location.location = self.getValue(field: field)
                            location.save { docRef, _ in
                                data[field] = docRef
                                dispatch.leave()
                            }
                        }
                    }
                default: dispatch.leave(); return
                }
            }
        }

        dispatch.notify {
            complete(data)
        }
    }

    private func setDocRef(collection: Assets.Collection, value: String?, docRef: DocumentReference?, _ complete: @escaping (DocumentReference?) -> Void) {
        if let docRef = docRef {
            complete(docRef)
            return
        }
        createFieldCollection(collection: collection, value: value) { newDocRef, _ in
            complete(newDocRef)
        }
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
        default: return
        }
    }

    private func setValue(data: [Field: DocumentReference?]) {
        Field.allCases.forEach { field in
            guard let value = data[field] else { return }
            switch field.type {
            case .persons:
                if field == .user { self.user = value?.documentID }
                if field == .admin { self.admin = value?.documentID }

            case .locations:
                self.location = value?.documentID

            case .assetNames:
                self.name = value?.documentID
            default: return
            }
        }
    }

    private func setValue(_ complete: @escaping () -> Void) {
        let dispatch = Dispatch(label: "value")

        Field.allCases.forEach { field in
            switch field.type {
            case .persons:
                if field == .user, let user = user {
                    dispatch.async {
                        Persons.get(user) { person, _ in
                            self.user = person?.name
                            dispatch.leave()
                        }
                    }
                }
                if field == .admin, let admin = admin {
                    dispatch.async {
                        Persons.get(admin) { person, _ in
                            self.admin = person?.name
                            dispatch.leave()
                        }
                    }
                }

            case .locations:
                if let location = location {
                    dispatch.async {
                        Locations.get(location) { location, _ in
                            self.location = location?.location
                            dispatch.leave()
                        }
                    }
                }

            case .assetNames:
                if let assetName = name {
                    dispatch.async {
                        AssetNames.get(assetName) { assetName, _ in
                            self.name = assetName?.assetName
                            dispatch.leave()
                        }
                    }
                }

            default:
                dispatch .async {
                    dispatch.leave()
                    return
                }
            }
        }

        dispatch.notify {
            complete()
        }
    }
}
