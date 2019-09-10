//
//  fireStoreStore.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation

internal class DBStore {
    static let shared = DBStore()
    private let fireStore = Firestore.firestore()

    private var convertId: [(collection: Collection, asset: Asset.AssetID)] {
        return [
            (.users, .user),
            (.admins, .admin),
            (.assetNames, .name),
            (.locations, .location)
        ]
    }

    private init() {}

    private enum Collection: String {
        case assets
        case users
        case admins
        case assetNames
        case locations

        internal var name: String {
            return self.rawValue
        }

        internal var docFieldName: String {
            switch self {
            case .users, .admins:
                return "name"
            case .assetNames:
                return "assetName"
            case .locations:
                return "location"
            case .assets:
                return "code"
            }
        }
    }

    internal func updateAsset(asset: Asset, _ completion: @escaping () -> Void, error: @escaping (Error) -> Void) {
        existDocumentProcess(user: asset.user, admin: asset.admin, assetName: asset.name, location: asset.location) {[weak self] userRef, adminRef, assetNameRef, locationRef in
            var data: [AnyHashable: Any] = asset.data
            if let userRef = userRef {
                data[Asset.AssetID.user.key] = userRef
            }
            if let adminRef = adminRef {
                data[Asset.AssetID.admin.key] = adminRef
            }
            if let assetNameRef = assetNameRef {
                data[Asset.AssetID.name.key] = assetNameRef
            }
            if let locationRef = locationRef {
                data[Asset.AssetID.location.key] = locationRef
            }
            data[Asset.AssetID.updateDate.key] = FieldValue.serverTimestamp()
            guard let self = self else { return }
            self.fireStore.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: asset.code).getDocuments { querySnapshot, err in
                if let err = err {
                    error(err)
                    return
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    if !querySnapshot.isEmpty {
                        self.fireStore.collection(Collection.assets.name).document(querySnapshot.documents[0].documentID).updateData(data) { err in
                            if let err = err {
                                error(err)
                            } else {
                                completion()
                            }
                        }
                    }
                }
            }
        }
    }

    internal func getAsset(code: String? = nil, _ completion: @escaping ([Asset]) -> Void, _ error: @escaping (Error) -> Void) {
        var query: Query?

        if let code = code {
            query = fireStore.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: code)
        }

        if let query = query {
            query.getDocuments { [weak self] querySnapshot, err in
                if let err = err {
                    error(err)
                    return
                } else {
                    guard let self = self, let querySnapshot = querySnapshot else { return }
                    print("convert")
                    self.convert(documents: querySnapshot.documents) { items in
                        print("items count: \(items.count)")
                        completion(items)
                    }
                }
            }
        } else {
            fireStore.collection(Collection.assets.name).getDocuments { [weak self] querySnapshot, err in
                if let err = err {
                    error(err)
                    return
                } else {
                    guard let self = self, let querySnapshot = querySnapshot else { return }
                    self.convert(documents: querySnapshot.documents) { items in
                        print("items count: \(items.count)")
                        completion(items)
                    }
                }
            }
        }
    }

    internal func setAssets(asset: Asset, _ completion: @escaping () -> Void, _ error: @escaping (Error) -> Void) {
        existDocumentProcess(user: asset.user, admin: asset.admin, assetName: asset.name, location: asset.location) { [weak self] userRef, adminRef, assetNameRef, locationRef in
            guard let self = self else { return }
            self.fireStore.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: asset.code).getDocuments { [weak self] querySnapshot, err in
                guard let self = self, let querySnapshot = querySnapshot, err == nil else { return }
                if querySnapshot.isEmpty {
                    self.fireStore.collection(Collection.assets.name).addDocument(data: [
                        "code": asset.code,
                        "name": assetNameRef ?? "",
                        "admin": adminRef ?? "",
                        "user": userRef ?? "",
                        "loss": asset.loss,
                        "discard": asset.discard,
                        "location": locationRef ?? "",
                        "quantity": asset.quantity,
                        "createdDate": FieldValue.serverTimestamp(),
                        "updateDate": FieldValue.serverTimestamp()
                    ]) { err in
                        if let err = err {
                            error(err)
                        } else {
                            completion()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Utile
extension DBStore {
    private func convert(documents: [QueryDocumentSnapshot], _ completion: @escaping ([Asset]) -> Void) {
        let dispatch = Dispatch()

        var assets: [Asset] = []
        for document in documents {
            dispatch.async(label: "completion") { [weak self] in
                guard let self = self else { dispatch.leave(); return }
                self.convertAsset(document: document) { asset in
                    print("completion")
                    assets.append(asset)
                    dispatch.leave()
                }
            }
        }

        dispatch.notify(label: "completion") {
            print("notify: completion")
            completion(assets)
        }
    }

    private func convertAsset(document: QueryDocumentSnapshot, comp: @escaping (Asset) -> Void) {
        let dispatch = Dispatch()

        var data = document.data()
        for id in convertId {
            if let docId = data[id.asset.key] as? String {
                dispatch.async(label: "convert") { [weak self] in
                    guard let self = self else { dispatch.leave(); return }
                    self.fireStore.collection(id.collection.name).document(docId).getDocument { doc, _ in
                        guard let doc = doc else { dispatch.leave(); return }
                        data[id.asset.key] = doc.data()?[id.collection.docFieldName] as? String
                        dispatch.leave()
                    }
                }
            }
        }

        dispatch.notify(label: "convert") {
            print("notify: convert")
            print("data: \(data)")
            if let asset = Asset(data: data) {
                comp(asset)
            }
        }
    }

    private func addDocumentWithExist(collection: Collection, item: String, _ comp: @escaping (String) -> Void) {
        fireStore.collection(collection.name).whereField(collection.docFieldName, isEqualTo: item).getDocuments { [weak self] querySnapshot, err in
            guard let self = self, let querySnapshot = querySnapshot, err == nil else { return }
            if querySnapshot.isEmpty {
                let docRef = self.fireStore.collection(collection.name).addDocument(data: [collection.docFieldName: item])
                comp(docRef.documentID)
            } else {
                comp(querySnapshot.documents[0].documentID)
            }
        }
    }

    private func existDocumentProcess(user: String? = nil, admin: String? = nil, assetName: String? = nil, location: String? = nil, _ comp: @escaping (String?, String?, String?, String?) -> Void) {
        let dispatch = Dispatch()
        var userRef: String?
        var adminRef: String?
        var assetNameRef: String?
        var locationRef: String?

        if let user = user {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .users, item: user) { docId in
                    userRef = docId
                    dispatch.leave()
                }
            }
        }
        if let admin = admin {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .admins, item: admin) { docId in
                    adminRef = docId
                    dispatch.leave()
                }
            }
        }
        if let assetName = assetName {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .assetNames, item: assetName) { docId in
                    assetNameRef = docId
                    dispatch.leave()
                }
            }
        }
        if let location = location {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .locations, item: location) { docId in
                    locationRef = docId
                    dispatch.leave()
                }
            }
        }

        dispatch.notify(label: "add") {
            comp(userRef, adminRef, assetNameRef, locationRef)
        }
    }
}
