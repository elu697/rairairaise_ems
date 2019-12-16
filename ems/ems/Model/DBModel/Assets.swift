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
import PromiseKit

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
        convertDocRef().done { data in
            self.setField(data: data)
            self.update { error in
                result(error)
            }
        }
        .catch { error in
            result(error)
        }
    }

    internal func saveWithSetParam(_ result: @escaping (Error?) -> Void) {
        convertDocRef().done { data in
            self.setField(data: data)
            self.save { _, error in
                result(error)
            }
        }
        .catch { error in
            result(error)
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

    internal func setValue(value: [Field: Any?]) {
        guard let code = value[.code] as? String else { return }
        self.code = code
        name = value[.name] as? String
        admin = value[.admin] as? String
        user = value[.user] as? String
        location = value[.location] as? String
        loss = value[.loss] as? Bool ?? false
        discard = value[.discard] as? Bool ?? false
        quantity = Int(value[.quantity] as? String ?? "0") ?? 0
    }
}

// MARK: - private function
extension Assets {
    /// 生の情報からDocumentReferenceを取得する。ない場合はデータをDBへ追加して取得する。
    private func convertDocRef() -> Promise<[Field: String]> {
        var data: [Field: String] = [:]

        return Promise<[Field: String]> { seal in
            firstly {
                prosess(field: .admin)
            }.then { docRef -> Promise<DocumentReference> in
                data[.admin] = docRef.documentID
                return self.prosess(field: .user)
            }
            .then { docRef -> Promise<DocumentReference> in
                data[.user] = docRef.documentID
                return self.prosess(field: .location)
            }
            .then { docRef -> Promise<DocumentReference> in
                data[.location] = docRef.documentID
                return self.prosess(field: .name)
            }
            .done { docRef in
                data[.name] = docRef.documentID
                seal.fulfill(data)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    private func prosess(field: Field) -> Promise<DocumentReference> {
        let value = getValue(field: field)
        switch field.type {
        case .persons:
            return Persons.existCheck(keyPath: \Persons.name, value: value).recover { _ -> Promise<DocumentReference> in
                Persons(value: value).save()
            }

        case .locations:
            return Locations.existCheck(keyPath: \Locations.location, value: value).recover { _ -> Promise<DocumentReference> in
                Locations(value: value).save()
            }

        case .assetNames:
            return AssetNames.existCheck(keyPath: \AssetNames.assetName, value: value).recover { _ -> Promise<DocumentReference> in
                AssetNames(value: value).save()
            }

        default:
            return Promise<DocumentReference>(error: DBStoreError.failed)
        }
    }

    private func setField(data: [Field: Any]) {
        code = data[.code] as? String ?? code
        name = data[.name] as? String ?? name
        admin = data[.admin] as? String ?? admin
        user = data[.user] as? String ?? user
        location = data[.location] as? String ?? location
        quantity = data[.quantity] as? Int ?? quantity
        discard = data[.discard] as? Bool ?? discard
        loss = data[.loss] as? Bool ?? loss
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
