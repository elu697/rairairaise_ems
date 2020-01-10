//
//  TextField.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Material

extension TextField {
    var emptyText: String? {
        return text?.isEmptyInWhiteSpace ?? true ? nil : text
    }
}
