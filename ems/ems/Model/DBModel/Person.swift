//
//  Users.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import FirebaseFirestore
import Foundation
import Pring

@objcMembers
internal class Persons: Object {
    dynamic var name: String?

    static func isExist(value: String?, _ result: @escaping (String?, Error?) -> Void) {
        guard let name = value else { result(nil, NSError(domain: "not input value", code: -1)); return }
        Persons.where(\Persons.name, isEqualTo: name).limit(to: 1).get { snapShot, error in
            if let error = error {
                result(nil, error)
            } else {
                guard let snapShot = snapShot else { result(nil, error); return }
                print("snapShot: \(snapShot.count)")
                if snapShot.isEmpty {
                    let user = Persons()
                    user.name = value
                    user.save { docRef, saveError in
                        result(docRef?.documentID, saveError)
                    }
                    return
                }
                result(snapShot.documents[0].documentID, error)
            }
        }
    }
}
