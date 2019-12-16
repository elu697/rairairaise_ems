//
//  DBStoreError.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/15.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

internal enum DBStoreError: Error {
    case existCode
    case failed
    case notFound
    case inputFailed

    var descript: String {
        switch self {
        case .existCode:
            return "既にその資産コードは登録されています。"
        case .failed:
            return "処理に失敗しました。"
        case .notFound:
            return "お探しの資産情報は見つかりませんでした。"
        case .inputFailed:
            return "入力が不正です。"
        }
    }
}
