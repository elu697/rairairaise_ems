//
//  ScanViewController.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import SPPermission

class ScanViewController: UIViewController {
    //MARK: - Property
    let scanView = ScanView()
    let scanReader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)

    //MARK: - Default
    override func loadView() {
        super.loadView()
        //self.viewとself.scanViewは同じメモリアドレスだからself.scanViewがsuperView
        self.view = self.scanView
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        self.scanView.backgroundColor = .white
        self.actionSetting()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Permission(vc: self).checkCameraPermission()
        self.scanReader.startScanning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanReader.stopScanning()
    }

    //MARK: - Layout
    //MARK: - Function
    private func actionSetting() {
        self.scanView.flashBtn.addTarget(self, action: #selector(tappedFlashBtn), for: .touchUpInside)
        self.scanView.scanBtn.addTarget(self, action: #selector(tappedScanBtn), for: .touchUpInside)
        self.scanView.profileBtn.addTarget(self, action: #selector(tappedProfileBtn), for: .touchUpInside)
        self.scanView.menuBtn.addTarget(self, action: #selector(tappedMenuBtn), for: .touchUpInside)
        self.scanView.settingBtn.addTarget(self, action: #selector(tappedSettingBtn), for: .touchUpInside)

        self.scanView.scanerSetting(scaner: self.scanReader, { (result) in
            print(result.value)
            self.scanView.previewQrInfo(msg: result.value)
        }) {
            self.scanView.previewQrInfo(msg: "error")
        }
    }

    //MARK: - Action
    @objc private func tappedScanBtn() {
        Sound.tone(mode: .success)//ok
//        Sound.tone(mode: .ringing)//error

    }

    @objc private func tappedFlashBtn() {
        self.scanReader.toggleTorch()
        Sound.tone(mode: .x3dtouch)
    }

    @objc private func tappedProfileBtn() {
        let contentVC = ProfileViewController()
        contentVC.modalPresentationStyle = .popover
        contentVC.preferredContentSize = CGSize(width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.7)
        contentVC.popoverPresentationController?.sourceView = view
        contentVC.popoverPresentationController?.sourceRect = self.scanView.profileBtn.frame
        contentVC.popoverPresentationController?.permittedArrowDirections = .any
        contentVC.popoverPresentationController?.delegate = self
        present(contentVC, animated: true, completion: nil)
    }

    @objc private func tappedMenuBtn() {
        self.pushNewNavigationController(rootViewController: MenuViewController())
    }

    @objc private func tappedSettingBtn() {
        self.pushNewNavigationController(rootViewController: SettingViewController())

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScanViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
