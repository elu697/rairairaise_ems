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

    private init() {}

    enum DBID: String {
        case users
        case admins
        case assetNames
        case locations

        internal var key: String {
            return self.rawValue
        }

        internal var field: String {
            switch self {
            case .users, .admins:
                return "name"
            case .assetNames:
                return "assetName"
            case .locations:
                return "location"
            }
        }
    }
    
    func updateAsset() {
        
    }

    func getAssets(code: String, completion: @escaping ([Asset]) -> Void, error: @escaping (Error) -> Void) {
        db.collection("assets").getDocuments {[weak self] querySnapshot, err in
            if let err = err {
                error(err)
            } else {
                guard let self = self, let querySnapshot = querySnapshot else { return }
                var assets: [Asset] = []

                let docDispatchGroup = DispatchGroup()
                let docDispatchQueue = DispatchQueue(label: "docQueue", attributes: .concurrent)

                for document in querySnapshot.documents {
                    var data = document.data()
                    docDispatchGroup.enter()
                    docDispatchQueue.async(group: docDispatchGroup) { [weak self] in
                        guard let self = self else { docDispatchGroup.leave(); return }
                        self.convert(data: data) { converted in
                            if let conv = converted[Asset.AssetID.user.key] { data[Asset.AssetID.user.key] = conv }
                            if let conv = converted[Asset.AssetID.admin.key] { data[Asset.AssetID.admin.key] = conv }
                            if let conv = converted[Asset.AssetID.name.key] { data[Asset.AssetID.name.key] = conv }
                            if let conv = converted[Asset.AssetID.location.key] { data[Asset.AssetID.location.key] = conv }

                            if let asset = Asset(data: data) {
                                assets.append(asset)
                            }
                            docDispatchGroup.leave()
                        }
                    }
                }
                docDispatchGroup.notify(queue: .main) {
                    completion(assets)
                }
            }
        }
    }

    private func convert(data: [String: Any], _ completion: @escaping ([String: String?]) -> Void) {
        let convertId: [(collection: DBID, asset: Asset.AssetID)] = [
                                                                 (.users, .user),
                                                                 (.admins, .admin),
                                                                 (.assetNames, .name),
                                                                 (.locations, .location)
        ]

        var conv: [String: String?] = [:]
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        for id in convertId {
            if let docId = data[id.asset.key] as? String {
                dispatchGroup.enter()
                dispatchQueue.async(group: dispatchGroup) { [weak self] in
                    guard let self = self else { dispatchGroup.leave(); return }
                    self.db.collection(id.collection.key).document(docId).getDocument { doc, _ in
                        guard let doc = doc else { return }
                        conv[id.asset.key] = doc.data()?[id.collection.field] as? String
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: dispatchQueue) {
            completion(conv)
        }
    }

    func setAssets(asset: Asset) {
        let userRef = db.collection(DBID.users.key).addDocument(data: [DBID.users.field: asset.user])

        let adminRef = db.collection(DBID.admins.key).addDocument(data: [DBID.admins.field: asset.admin])

        let assetNameRef = db.collection(DBID.assetNames.key).addDocument(data: [DBID.assetNames.field: asset.name])

        let locationRef = db.collection(DBID.locations.key).addDocument(data: [DBID.locations.field: asset.location])

        db.collection("assets").addDocument(data: [
            "code": asset.code,
            "name": assetNameRef.documentID,
            "admin": adminRef.documentID,
            "user": userRef.documentID,
            "loss": asset.loss,
            "discard": asset.discard,
            "location": locationRef.documentID,
            "quantity": asset.quantity,
            "createdDate": asset.createdDate,
            "updateDate": asset.updateDate
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
}
