//
//  Asset.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/10.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation

internal struct Asset {
    internal let code: String
    internal let name: String?
    internal let admin: String?
    internal let user: String?
    internal let loss: Bool
    internal let discard: Bool
    internal let location: String?
    internal let quantity: Int?
    internal let createdDate: Timestamp?
    internal let updateDate: Timestamp?

    internal enum AssetID: String {
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

        internal var key: String {
            return self.rawValue
        }
    }

    internal var data: [AnyHashable: Any] {
        var asset: [AnyHashable: Any] = [:]
        asset[AssetID.code.key] = code
        asset[AssetID.loss.key] = loss
        asset[AssetID.discard.key] = discard

        if let name = name {
            asset[AssetID.name.key] = name
        }
        if let admin = admin {
            asset[AssetID.admin.key] = admin
        }
        if let user = user {
            asset[AssetID.user.key] = user
        }
        if let location = location {
            asset[AssetID.location.key] = location
        }
        if let quantity = quantity {
            asset[AssetID.quantity.key] = quantity
        }
        return asset
    }

    internal init(code: String, name: String? = nil, admin: String? = nil, user: String? = nil, loss: Bool = false, discard: Bool = false, location: String? = nil, quantity: Int? = nil) {
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

    internal init?(data: [String: Any]) {
        guard let code = data[AssetID.code.key] as? String,
              let createdDate = data[AssetID.createdDate.key] as? Timestamp,
              let updateDate = data[AssetID.updateDate.key] as? Timestamp else { return nil }

        self.code = code
        self.createdDate = createdDate
        self.updateDate = updateDate
        name = data[AssetID.name.key] as? String
        admin = data[AssetID.admin.key] as? String
        user = data[AssetID.user.key] as? String
        loss = data[AssetID.loss.key] as? Bool ?? false
        discard = data[AssetID.discard.key] as? Bool ?? false
        location = data[AssetID.location.key] as? String
        quantity = data[AssetID.quantity.key] as? Int
    }
}
