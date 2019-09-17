//
//  Locations.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Pring

@objcMembers
internal class Locations: Object {
    dynamic var location: String?

    static func isExist(value: String?, _ result: @escaping (String?, Error?) -> Void) {
        guard let location = value else { result(nil, NSError(domain: "not input value", code: -1)); return }
        Locations.where(\Locations.location, isEqualTo: location).limit(to: 1).get { snapShot, error in
            if let error = error {
                result(nil, error)
            } else {
                guard let snapShot = snapShot else { return }
                if snapShot.isEmpty {
                    let location = Locations()
                    location.location = value
                    location.save { docRef, saveError in
                        result(docRef?.documentID, saveError)
                    }
                    return
                }
                result(snapShot.documents[0].documentID, error)
            }
        }
    }
}
