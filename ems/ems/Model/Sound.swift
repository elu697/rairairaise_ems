//
//  Sound.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import Foundation

// swiftlint:disable:next convenience_type
internal class Sound {
    internal enum SoundMode: Int {
        ///フゥォオン
        case success = 1_050
        ///ヴィ
        case fail = 1_051
        ///ピン
        case detect = 1_052
        ///ビ
        case error = 1_053
        ///バイブ
        case minivibe = 1_107
        ///ピロロロン
        case shake = 1_109
        ///ヴィオン
        case accept = 1_150
        ///プロロロロロ
        case ringing = 1_151
        ///フィロン
        case end = 1_152
        ///3Dタッチの振動ぴろろろろん
        case x3dtouch = 1_162
        ///録画開始の音
        case x3dtouch2 = 1_163
        case x3dtouch3 = 1_164
        ///2トーンの音が上がったり下がったり
        case twotone = 1_263
        case twotone2 = 1_264
    }

    internal static func tone(mode: SoundMode) {
        AudioServicesPlaySystemSound(SystemSoundID(mode.rawValue))
    }
}
