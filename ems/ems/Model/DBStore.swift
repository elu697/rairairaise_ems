//
//  DBStore.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/08.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation

internal class DBStore {
    static let shared = DBStore()
    private let db = Firestore.firestore()

    private var convertId: [(collection: Collection, asset: Asset.AssetID)] {
        return [
            (.users, .user),
            (.admins, .admin),
            (.assetNames, .name),
            (.locations, .location)
        ]
    }

    private init() {}

    enum Collection: String {
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

    func updateAsset(asset: Asset, error: @escaping (Error) -> Void) {
        db.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: asset.code).limit(to: 1).getDocuments { [weak self] querySnapshot, err in
            if let err = err {
                error(err)
                return
            } else {
                guard let self = self, let querySnapshot = querySnapshot else { return }
                if !querySnapshot.isEmpty {
                    self.db.collection(Collection.assets.name).document(querySnapshot.documents[0].documentID).updateData(asset.data) { err in
                        if let err = err {
                            error(err)
                        }
                    }
                }
            }
        }
    }

    func getAsset(code: String?, completion: @escaping ([Asset]) -> Void, error: @escaping (Error) -> Void) {
        var query: Query?

        if let code = code {
            query = db.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: code)
        }

        if let query = query {
            query.getDocuments { [weak self] querySnapshot, err in
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
        } else {
            db.collection(Collection.assets.name).getDocuments { [weak self] querySnapshot, err in
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

    private func convert(documents: [QueryDocumentSnapshot], _ completion: @escaping ([Asset]) -> Void) {
        let dispatch = Dispatch()

        var assets: [Asset] = []
        for document in documents {
            dispatch.async(label: "completion") { [weak self] in
                guard let self = self else { dispatch.leave(); return }
                self.convertAsset(document: document) { asset in
                    assets.append(asset)
                    dispatch.leave()
                }
            }
        }

        dispatch.notify(label: "completion") {
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
                    self.db.collection(id.collection.name).document(docId).getDocument { doc, _ in
                        guard let doc = doc else { dispatch.leave(); return }
                        data[id.asset.key] = doc.data()?[id.collection.docFieldName] as? String
                        dispatch.leave()
                    }
                }
            }
        }

        dispatch.notify(label: "convert") {
            print("notify")
            if let asset = Asset(data: data) {
                comp(asset)
            }
        }
    }

    private func addDocumentWithExist(collection: Collection, item: String, comp: @escaping (String) -> Void) {
        db.collection(collection.name).whereField(collection.docFieldName, isEqualTo: item).getDocuments { [weak self] querySnapshot, err in
            guard let self = self, let querySnapshot = querySnapshot, err == nil else { return }
            if querySnapshot.isEmpty {
                let docRef = self.db.collection(collection.name).addDocument(data: [collection.docFieldName: item])
                comp(docRef.documentID)
            } else {
                comp(querySnapshot.documents[0].documentID)
            }
        }
    }

    func setAssets(asset: Asset, _ error: @escaping (Error) -> Void) {
        var userRef: String?
        var adminRef: String?
        var assetNameRef: String?
        var locationRef: String?

        let dispatch = Dispatch()

        if let user = asset.user {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .users, item: user) { docId in
                    userRef = docId
                    dispatch.leave()
                }
            }
        }
        if let admin = asset.admin {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .admins, item: admin) { docId in
                    adminRef = docId
                    dispatch.leave()
                }
            }
        }
        if let assetName = asset.name {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .assetNames, item: assetName) { docId in
                    assetNameRef = docId
                    dispatch.leave()
                }
            }
        }
        if let location = asset.location {
            dispatch.async(label: "add") { [weak self] in
                guard let self = self else { return }
                self.addDocumentWithExist(collection: .locations, item: location) { docId in
                    locationRef = docId
                    dispatch.leave()
                }
            }
        }

        dispatch.notify(label: "add") { [weak self] in
            print("add userRef: \(userRef!)")
            print("add adminRef: \(adminRef!)")
            print("add assetNameRef: \(assetNameRef!)")
            print("add locationRef: \(locationRef!)")

            guard let self = self else { return }
            self.db.collection(Collection.assets.name).whereField(Asset.AssetID.code.key, isEqualTo: asset.code).getDocuments { [weak self] querySnapshot, err in
                guard let self = self, let querySnapshot = querySnapshot, err == nil else { return }
                if querySnapshot.isEmpty {
                    self.db.collection(Collection.assets.name).addDocument(data: [
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
                            print("Error adding document: \(err)")
                            error(err)
                        } else {
                            print("Document added")
                        }
                    }
                }
            }
        }
    }
}
