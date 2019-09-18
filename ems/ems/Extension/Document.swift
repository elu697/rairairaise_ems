//
//  Document.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/18.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Pring

extension Document where Self: Object {
    static func isExist(keyPath: PartialKeyPath<Self>, value: Any, _ exist: @escaping (String?, Error?) -> Void) {
        if let key = keyPath._kvcKeyPathString {
            Self.where(key, isEqualTo: value).get { snapShot, error in
                if let error = error {
                    exist(nil, error)
                } else {
                    guard let snapShot = snapShot else { exist(nil, error); return }
                    exist(snapShot.isEmpty ? nil : snapShot.documents[0].documentID, nil)
                }
            }
        }
    }
}
