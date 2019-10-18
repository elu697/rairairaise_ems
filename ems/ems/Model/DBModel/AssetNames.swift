//
//  AssetNames.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Pring

@objcMembers
internal class AssetNames: Object {
    internal dynamic var assetName: String?

    internal static func getDocumentId(value: String, _ complete: @escaping (QueryDocumentSnapshot?, Error?) -> Void) {
        self.where(\AssetNames.assetName, isEqualTo: value).get { snapShot, error in
            guard let snapShot = snapShot else {
                complete(nil, error)
                return
            }
            if let first = snapShot.documents.first {
                complete(first, nil)
            } else {
                let assetName = AssetNames()
                assetName.assetName = value
                assetName.save { _, _ in
                    getDocumentId(value: value, complete)
                }
            }
        }
    }
}
