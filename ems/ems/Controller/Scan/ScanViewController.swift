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
import UIKit

internal class ScanViewController: UIViewController {
    // MARK: - Property
    internal let scanReader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
    internal let infoViewList = [ScanInfoInputViewController.self, ScanAssetCheckListViewController.self]
    internal var currentView: MenuViewController.MenuType = MenuViewController.MenuType.change

    private var beforeQrData = ""
    private var scanQrData = String()
    private var scanQrDatas = [String]()

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

    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        hideKeyboardWhenTappedAround()
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
    }
}

// MARK: - Function
extension ScanViewController {
    private func scanerSetting() {
        guard let view = view as? ScanView else { return }
        scanReader.didFindCode = { result in
            if self.beforeQrData != result.value {
                self.beforeQrData = result.value
                view.scanPreviewView.overlayView?.setState(.valid)
            } else {
                view.scanPreviewView.overlayView?.setState(.normal)
            }
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
        scanView.profileBtn.addTarget(self, action: #selector(tappedProfileBtn), for: .touchUpInside)
        scanView.menuBtn.addTarget(self, action: #selector(tappedMenuBtn), for: .touchUpInside)
        scanView.settingBtn.addTarget(self, action: #selector(tappedSettingBtn), for: .touchUpInside)

        /*scanView.scanerSetting(
            // swiftlint:disable:next multiline_arguments
            scaner: scanReader, { result in
                // TODO: TODO Network
                scanView.previewQrInfo(msg: result.value)
                self.scanQrData = result.value
            }, {
                scanView.previewQrInfo(msg: "error")
            }
        )*/
    }
}

// MARK: - Action
extension ScanViewController {
    @objc
    private func tappedScanBtn() {
        guard let scanView = view as? ScanView else { return }
        if scanQrData.isEmpty {
            Sound.tone(mode: .fail)
            scanView.previewQrInfo(msg: "QRコードが読み込まれていません")
        } else {
            Sound.tone(mode: .accept)//ok
            scanQrDatas.append(self.scanQrData)
            scanQrData.removeAll()
            scanView.previewQrInfo(msg: "")
            scanView.previewScanInfo(msg: "\(scanQrDatas.count)品スキャン済み")
            //self.scanView.scanInfoView.setAssetData(data: Asset(code: "0001", name: "テスト机", admin: "テスター", user: "テスター", loss: true, discard: true, location: "nil", quantity: 1))
        }
    }

    @objc
    private func tappedFlashBtn() {
        self.scanReader.toggleTorch()
        Sound.tone(mode: .x3dtouch)
    }

    @objc
    private func tappedProfileBtn() {
        guard let scanView = view as? ScanView else { return }
        let contentVC = ProfileViewController()
        contentVC.modalPresentationStyle = .popover
        contentVC.preferredContentSize = CGSize(width: view.bounds.width * 0.6, height: view.bounds.height * 0.2)
        contentVC.popoverPresentationController?.sourceView = view
        contentVC.popoverPresentationController?.sourceRect = scanView.profileBtn.frame
        contentVC.popoverPresentationController?.permittedArrowDirections = .any
        contentVC.popoverPresentationController?.delegate = self
        contentVC.delegate = self
        present(contentVC, animated: true, completion: nil)
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
            let vc = RegisterViewController()
            present(vc, animated: true, completion: nil)
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
            vc.fetch(value: value)
        }
    }
}
