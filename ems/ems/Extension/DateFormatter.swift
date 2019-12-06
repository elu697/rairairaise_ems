//
//  DateFormatter.swift
//  ems
//
//  Created by El You on 2019/12/06.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

extension DateFormatter {
    enum Template: String {
        /// 2017/1/1
        case date = "yMd"
        /// 12:39:22
        case time = "Hms"
        /// 2017/1/1 12:39:22
        case full = "yMdkHms"
        /// 17時
        case onlyHour = "k"
        /// "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case era = "GG"
        /// 日曜日
        case weekDay = "EEEE"
    }
    
    func setTemplate(_ template: Template) {
        /// optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}
