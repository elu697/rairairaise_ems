//
//  User.swift
//  ems
//
//  Created by 吉野瑠 on 2019/08/10.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

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
    let createdDate: String
    let updateDate: String

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

    init?(data: [String: Any]) {
        guard let code = data[AssetID.code.key] as? String,
              let createdDate = data[AssetID.createdDate.key] as? String,
              let updateDate = data[AssetID.updateDate.key] as? String else { return nil }

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
