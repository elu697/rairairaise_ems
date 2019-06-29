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
        case success = 1050
        case fail = 1051
        case detect = 1052
        case error = 1053
        

    }

    static func tone(mode: SoundMode) {
        AudioServicesPlaySystemSound(SystemSoundID(mode.rawValue))
    }
}
