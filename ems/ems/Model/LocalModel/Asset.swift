//
//  Asset.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/28.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

struct Asset {
    var code: String?
    var name: String?
    var admin: String?
    var user: String?
    var loss: Bool = false
    var discard: Bool = false
    var location: String?
    var quantity: Int = 0
    var checkedAt: Date?

    var validated: Bool {
        return validate()
    }

    var value: [String: Any] {
        var buf: [String: Any] = [:]
        buf["code"] = code
        buf["name"] = name?.isEmptyInWhiteSpace ?? false ? "" : name
        buf["admin"] = admin?.isEmptyInWhiteSpace ?? false ? "" : admin
        buf["user"] = user?.isEmptyInWhiteSpace ?? false ? "" : user
        buf["location"] = location?.isEmptyInWhiteSpace ?? false ? "" : location
        buf["discard"] = discard
        buf["loss"] = loss
        buf["quantity"] = quantity
        buf["checkedAt"] = checkedAt
        return buf
    }

    init() {}

    init(value: [String: Any]) {
        code = value["code"] as? String ?? ""
        name = value["name"] as? String ?? ""
        admin = value["admin"] as? String ?? ""
        user = value["user"] as? String ?? ""
        loss = value["loss"] as? Bool ?? false
        discard = value["discard"] as? Bool ?? false
        location = value["location"] as? String ?? ""
        if let quantity = value["quantity"] as? Int {
            self.quantity = quantity
        } else {
            self.quantity = Int(value["quantity"] as? String ?? "0") ?? 0
        }
        checkedAt = value["checkedAt"] as? Date
    }

    private func validate() -> Bool {
        return !(code?.isEmptyInWhiteSpace ?? true)
    }
}
