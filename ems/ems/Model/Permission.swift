//
//  Permission.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class Permission {
    private var vc: UIViewController

    init(vc: UIViewController) {
        self.vc = vc
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            requestCameraPermission()

        case .restricted, .denied:
            alertCameraAccessNeeded()

        case .authorized:
            break
        @unknown default:
            break
        }
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            guard accessGranted == true else { return }
        })
    }

    private func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: NSLocalizedString("カメラへのアクセスのアクセスが許可されていません", comment: ""),
            message: NSLocalizedString("QRコードを読み込むためにカメラを利用します", comment: ""),
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: NSLocalizedString("許可しない", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        vc.present(alert, animated: true, completion: nil)
    }
}
