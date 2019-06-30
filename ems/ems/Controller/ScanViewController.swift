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

    private var scanCode: String = ""

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
        self.scanerSetting()
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
    private func scanerSetting() {
        let scanViewBuild = QRCodeReaderViewControllerBuilder { (build) in
            build.reader = self.scanReader
            build.showTorchButton = true
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.handleOrientationChange = true
            build.rectOfInterest = CGRect(x: 0.2, y: 0.125, width: 0.6, height: 0.3)
            build.preferredStatusBarStyle = .default
        }
        self.scanView.scanPreviewView.setupComponents(with: scanViewBuild)

        self.scanReader.didFindCode = { (result) in
            if result.value != self.scanCode {
                self.scanCode = result.value
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.scanView.scanPreviewView.overlayView?.setState(.normal)
                    self.scanCode.removeAll()
                }
                Sound.tone(mode: .success)
                self.scanView.scanPreviewView.overlayView?.setState(.valid)
                //TODO: TODO
                print(result)
            }
        }

        self.scanReader.didFailDecoding = { () in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.scanView.scanPreviewView.overlayView?.setState(.normal)
            }
            Sound.tone(mode: .fail)
            self.scanView.scanPreviewView.overlayView?.setState(.wrong)
        }
        self.scanReader.stopScanningWhenCodeIsFound = false
        self.scanReader.startScanning()
    }

    private func actionSetting() {
        self.scanView.scanPreviewView.toggleTorchButton?.addTarget(self, action: #selector(tappedTorchBtn), for: .touchUpInside)
        self.scanView.scanBtn.addTarget(self, action: #selector(tappedScanBtn), for: .touchUpInside)
        self.scanView.profileBtn.addTarget(self, action: #selector(tappedProfileBtn), for: .touchUpInside)
        self.scanView.menuBtn.addTarget(self, action: #selector(tappedMenuBtn), for: .touchUpInside)
        self.scanView.settingBtn.addTarget(self, action: #selector(tappedSettingBtn), for: .touchUpInside)
    }

    //MARK: - Action
    @objc private func tappedScanBtn() {
        Sound.tone(mode: .success)//ok
//        Sound.tone(mode: .ringing)//error

    }

    @objc private func tappedTorchBtn() {
        self.scanReader.toggleTorch()
        Sound.tone(mode: .x3dtouch)
    }

    @objc private func tappedProfileBtn() {
        let contentVC = ProfileViewController()
        // スタイルの指定
        contentVC.modalPresentationStyle = .popover
        // サイズの指定
        contentVC.preferredContentSize = CGSize(width: self.view.bounds.width*0.8, height: self.view.bounds.height*0.7)
        // 表示するViewの指定
        contentVC.popoverPresentationController?.sourceView = view
        // ピヨッと表示する位置の指定
        contentVC.popoverPresentationController?.sourceRect = self.scanView.profileBtn.frame
        // 矢印が出る方向の指定
        contentVC.popoverPresentationController?.permittedArrowDirections = .any
        // デリゲートの設定
        contentVC.popoverPresentationController?.delegate = self
        //表示
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
