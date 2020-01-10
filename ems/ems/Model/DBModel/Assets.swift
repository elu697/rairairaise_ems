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
class Assets: Object {
    dynamic var code: String = ""
    dynamic var name: String?
    dynamic var nameDocId: String?
    dynamic var admin: String?
    dynamic var adminDocId: String?
    dynamic var user: String?
    dynamic var userDocId: String?
    dynamic var loss: Bool = false
    dynamic var discard: Bool = false
    dynamic var location: String?
    dynamic var locationDocId: String?
    dynamic var quantity: Int = 0
    dynamic var checkedAt: Timestamp?

    enum Collection {
        case persons
        case locations
        case assetNames
        case assets
    }

    enum Field: String, CaseIterable {
        case code
        case name
        case admin
        case user
        case loss
        case discard
        case location
        case quantity

        var name: String {
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

    var dictionary: [String: Any] {
        var buf: [String: Any] = [:]
        buf["code"] = code
        buf["name"] = name
        buf["admin"] = admin
        buf["user"] = user
        buf["location"] = location
        buf["discard"] = discard
        buf["loss"] = loss
        buf["quantity"] = quantity
        buf["checkedAt"] = checkedAt?.dateValue()
        return buf
    }

    func set(_ value: [String: Any]) {
        code = value["code"] as? String ?? code
        name = value["name"] as? String ?? name
        admin = value["admin"] as? String ?? admin
        user = value["user"] as? String ?? user
        location = value["location"] as? String ?? location
        discard = value["discard"] as? Bool ?? discard
        loss = value["loss"] as? Bool ?? loss
        quantity = value["quantity"] as? Int ?? quantity
        if let checkedAt = value["checkedAt"] as? Date {
            self.checkedAt = Timestamp(date: checkedAt)
        }
    }

    static func copy(id: String? = nil, model: Asset) -> Assets {
        let copy = id != nil ? Assets(id: id!, value: [:]) : Assets()
        copy.code = model.code ?? ""
        copy.name = model.name
        copy.admin = model.admin
        copy.user = model.user
        copy.location = model.location
        copy.discard = model.discard
        copy.loss = model.loss
        copy.quantity = model.quantity
        if let checkedAt = model.checkedAt {
            copy.checkedAt? = Timestamp(date: checkedAt)
        }

        return copy
    }
}
