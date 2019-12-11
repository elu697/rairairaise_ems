//
//  String.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var lines = [String]()
        self.enumerateLines { line, _ -> Void in
            lines.append(line)
        }
        return lines
    }
}
