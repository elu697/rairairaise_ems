//
//  AssetNames.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Pring

@objcMembers
internal class AssetNames: Object {
    dynamic var assetName: String?

    static func isExist(value: String?, _ result: @escaping (String?, Error?) -> Void) {
        guard let assetName = value else { result(nil, NSError(domain: "not input value", code: -1)); return }
        AssetNames.where(\AssetNames.assetName, isEqualTo: assetName).limit(to: 1).get { snapShot, error in
            if let error = error {
                result(nil, error)
            } else {
                guard let snapShot = snapShot else { return }
                if snapShot.isEmpty {
                    let assetName = AssetNames()
                    assetName.assetName = value
                    assetName.save { docRef, saveError in
                        result(docRef?.documentID, saveError)
                    }
                    return
                }
                result(snapShot.documents[0].documentID, error)
            }
        }
    }
}
