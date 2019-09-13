//
//  Profile.swift
//  ems
//
//  Created by El You on 2019/09/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

class Profile {
    internal let name: String?
    internal let location: String?
    internal let admin: String?
    internal let user: String?

    init(name: String?, location: String?, admin: String?, user: String?) {
        self.name = name
        self.location = location
        self.admin = admin
        self.user = user
    }
}
