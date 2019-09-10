//
//  User.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/10.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct Asset {
    let code: String
    let name: String?
    let admin: String?
    let user: String?
    let loss: Bool?
    let discard: Bool?
    let location: String?
    let quantity: Int?
    let createdDate: Timestamp?
    let updateDate: Timestamp?

    enum AssetID: String {
        case code
        case name
        case admin
        case user
        case loss
        case discard
        case location
        case quantity
        case createdDate
        case updateDate

        var key: String {
            return self.rawValue
        }
    }

    var data: [AnyHashable: Any] {
        get {
            var asset: [AnyHashable: Any] = [:]
            asset[AssetID.code.key] = code

            if let name = name {
                asset[AssetID.name.key] = name
            }
            if let admin = admin {
                asset[AssetID.admin.key] = admin
            }
            if let user = user {
                asset[AssetID.user.key] = user
            }
            if let loss = loss {
                asset[AssetID.loss.key] = loss
            }
            if let discard = discard {
                asset[AssetID.discard.key] = discard
            }
            if let location = location {
                asset[AssetID.location.key] = location
            }
            if let quantity = quantity {
                asset[AssetID.quantity.key] = quantity
            }
            return asset
        }
    }

    init(code: String, name: String? = nil, admin: String? = nil, user: String? = nil, loss: Bool? = nil, discard: Bool? = nil, location: String? = nil, quantity: Int? = nil) {
        self.code = code
        self.name = name
        self.admin = admin
        self.user = user
        self.loss = loss
        self.discard = discard
        self.location = location
        self.quantity = quantity
        self.createdDate = nil
        self.updateDate = nil
    }

    init?(data: [String: Any]) {
        guard let code = data[AssetID.code.key] as? String,
              let createdDate = data[AssetID.createdDate.key] as? Timestamp,
              let updateDate = data[AssetID.updateDate.key] as? Timestamp else { return nil }

        self.code = code
        self.createdDate = createdDate
        self.updateDate = updateDate
        name = data[AssetID.name.key] as? String
        admin = data[AssetID.admin.key] as? String
        user = data[AssetID.user.key] as? String
        loss = data[AssetID.loss.key] as? Bool
        discard = data[AssetID.discard.key] as? Bool
        location = data[AssetID.location.key] as? String
        quantity = data[AssetID.quantity.key] as? Int
    }
}
