//
//  Sound.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    enum SoundMode: Int {

        ///フゥォオン
        case success = 1050
        ///ヴィ
        case fail = 1051
        ///ピン
        case detect = 1052
        ///ビ
        case error = 1053
        ///バイブ
        case minivibe = 1107
        ///ピロロロン
        case shake = 1109
        ///ヴィオン
        case accept = 1150
        ///プロロロロロ
        case ringing = 1151
        ///フィロン
        case end = 1152
        ///3Dタッチの振動ぴろろろろん
        case x3dtouch = 1162
        ///録画開始の音
        case x3dtouch2 = 1163
        case x3dtouch3 = 1164
        ///2トーンの音が上がったり下がったり
        case twotone = 1263
        case twotone2 = 1264

    }

    static func tone(mode: SoundMode) {
        AudioServicesPlaySystemSound(SystemSoundID(mode.rawValue))
    }
}
