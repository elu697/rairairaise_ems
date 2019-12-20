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
    internal dynamic var name: String?

    /*override required init() {
        fatalError("init() has not been implemented")
    }*/

    internal static func getDocumentId(value: String, _ complete: @escaping (QueryDocumentSnapshot?, Error?) -> Void) {
        self.where(\Persons.name, isEqualTo: value).get { snapShot, error in
            guard let snapShot = snapShot else {
                complete(nil, error)
                return
            }
            complete(snapShot.documents.first, nil)
        }
    }
}
