//
//  ScanViewController.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import Foundation
import QRCodeReader
import SPPermission
import SVProgressHUD
import UIKit

internal class ScanViewController: UIViewController {
    // MARK: - Property
    internal let scanReader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
    internal let infoViewList = [ScanInfoInputViewController.self, ScanAssetCheckListViewController.self]
    internal var currentView: MenuViewController.MenuType = MenuViewController.MenuType.change

    private var beforeQrData = ""
    private var scanQrData = String()
    private var scanQrDatas = [String]()
    private var searchValue = ""

    // view.contentView.boundsが0の時を回避するためのflag
    private var isFirstLoading = true

    // MARK: - Default
    override internal func loadView() {
        view = ScanView(scaner: scanReader)
    }

    override internal var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Permission(vc: self).checkCameraPermission()
        self.scanReader.startScanning()

        let viewController = infoViewList[currentView.rawValue].init()
        updateInfoView(viewController: viewController)
    }

    override internal func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanReader.stopScanning()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        actionSetting()
        setNeedsUpdateOfHomeIndicatorAutoHidden()
        // Do any additional setup after loading the view.

        scanerSetting()
    }

    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLoading {
            let viewController = infoViewList[currentView.rawValue].init()
            updateInfoView(viewController: viewController)
            guard let view = view as? ScanView else { return }
            isFirstLoading = view.contentView.bounds == .zero
        }
    }
}

// MARK: - Layout
extension ScanViewController {
    private func updateInfoView(viewController: UIViewController) {
        if !children.isEmpty {
            guard let child = children.first else { return }
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        guard let view = view as? ScanView, view.contentView.bounds != .zero else { return }
        addChild(viewController)
        viewController.view.frame = view.contentView.bounds
        view.contentView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        settingInfoLabel()
        settingUpdateBtn()
    }

    private func settingInfoLabel() {
        guard let view = view as? ScanView else { return }
//        view.qrInfoLbl.isHidden = children.first is ScanAssetCheckListViewController
        view.scanInfoLbl.isHidden = children.first is ScanAssetCheckListViewController
    }

    private func settingUpdateBtn() {
        guard let view = view as? ScanView else { return }
        view.updateBtn.isHidden = children.first is ScanAssetCheckListViewController
    }
}

// MARK: - Function
extension ScanViewController {
    private func scanerSetting() {
        guard let view = view as? ScanView else { return }
        scanReader.didNotFoundCode = {
            guard !self.scanQrData.isEmpty else { return }
            DispatchQueue.main.async {
                view.scanPreviewView.overlayView?.setState(.normal)
                self.scanQrData = ""
                view.previewQrInfo(msg: "")
            }
        }
        scanReader.didFindCode = { result in
            guard self.scanQrData.isEmpty && !result.value.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            DispatchQueue.main.async {
                view.scanPreviewView.overlayView?.setState(.valid)
            }
            self.scanQrData = result.value
            view.previewQrInfo(msg: result.value)
            Sound.tone(mode: .detect)
//            switch self.currentView {
//            case .check:
//                if let child = self.children.first as? ScanAssetCheckListViewController {
//                    DispatchQueue.main.async {
//                        child.check(code: result.value)
//                    }
//                }
//            case .change:
//                self.scanQrData = result.value
//            default: ()
//            }
        }

        scanReader.didFailDecoding = {
            view.scanPreviewView.overlayView?.setState(.wrong)
            print("error")
        }

        scanReader.stopScanningWhenCodeIsFound = false
        scanReader.startScanning()
    }

    private func actionSetting() {
        guard let scanView = view as? ScanView else { return }
        scanView.flashBtn.addTarget(self, action: #selector(tappedFlashBtn), for: .touchUpInside)
        scanView.scanBtn.addTarget(self, action: #selector(tappedScanBtn), for: .touchUpInside)
        scanView.menuBtn.addTarget(self, action: #selector(tappedMenuBtn), for: .touchUpInside)
        scanView.updateBtn.addTarget(self, action: #selector(tappedUpdateBtn), for: .touchUpInside)
        scanView.settingBtn.addTarget(self, action: #selector(tappedSettingBtn), for: .touchUpInside)
    }
}

// MARK: - Action
extension ScanViewController {
    @objc
    private func tappedScanBtn() {
        PDFDownloader.share.download()
        guard let scanView = view as? ScanView else { return }
        if scanQrData.isEmpty {
            if UDManager.getUD(key: .sound) as? Bool ?? false {
                Sound.tone(mode: .fail)
            }
            scanView.previewQrInfo(msg: "QRコードが読み込まれていません")
        } else {
            if UDManager.getUD(key: .sound) as? Bool ?? false {
                Sound.tone(mode: .accept)
            }
            scanView.previewQrInfo(msg: "")
//            scanView.previewScanInfo(msg: "\(scanQrDatas.count)品スキャン済み")
            if let child = self.children.first as? ScanAssetCheckListViewController {
                DispatchQueue.main.async {
                    child.check(code: self.scanQrData)
                }
            }
            if let child = self.children.first as? ScanInfoInputViewController {
                scanView.updateBtn.isEnabled = true
                child.fetch(value: scanQrData) { error in
                    guard let error = error else { return }
                    SVProgressHUD.showError(withStatus: error.descript)
                }
            }
        }
    }

    @objc
    private func tappedUpdateBtn() {
        if let child = children.first as? ScanInfoInputViewController {
            child.update()
        }
    }

    @objc
    private func tappedFlashBtn() {
        self.scanReader.toggleTorch()
        Sound.tone(mode: .x3dtouch)
    }

    @objc
    private func tappedMenuBtn() {
        let menu = MenuViewController()
        menu.modalPresentationStyle = .fullScreen
        menu.delegate = self
        pushNewNavigationController(rootViewController: menu)
    }

    @objc
    private func tappedSettingBtn() {
        self.pushNewNavigationController(rootViewController: SettingViewController())
    }
}

extension ScanViewController: UIPopoverPresentationControllerDelegate {
    internal func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ScanViewController: MenuDelegate {
    internal func modeChanged(type: MenuViewController.MenuType, viewController: UIViewController) {
        if type == .register {
            pushNewNavigationController(rootViewController: RegisterViewController())
            return
        }
        currentView = type
    }
}

extension ScanViewController: ProfileDelegate {
    internal func reload(value: String?) {
        if currentView == .check {
            guard let vc = children.first as? ScanAssetCheckListViewController, let value = value else { return }
            print("reload")
            vc.fetch(value: value) { error in
                SVProgressHUD.showError(withStatus: error.descript)
            }
            beforeQrData = ""
        }
    }
}
