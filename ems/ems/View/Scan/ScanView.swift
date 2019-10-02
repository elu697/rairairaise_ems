//
//  ScanView.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import Foundation
import Material
import UIKit

internal class ScanView: UIView {
    // MARK: - Property

    // view
    internal let scanPreviewView: QRCodeReaderView = {
        let scanPreviewView = QRCodeReaderView()
        scanPreviewView.backgroundColor = .black
        return scanPreviewView
    }()

    internal let scanBtn: UIButton = {
        let button = UIButton(type: .system)
        button.roundRadius = 35
        button.borderWidth = 5
        button.borderColor = .gray
        button.tintColor = .gray
        button.setImage(Constants.Image.qr, for: .normal)
        button.setBackgroundColor(color: .clear, forState: .normal)
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.addShadow(direction: .bottom, radius: 1, color: .black, opacity: 0.2)
        return button
    }()

    internal let profileBtn: IconButton = {
        let profileBtn = IconButton()
        profileBtn.image = Constants.Image.user
        profileBtn.tintColor = .white
        profileBtn.pulseColor = .white
        profileBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
        return profileBtn
    }()

    internal let menuBtn: IconButton = {
        let menuBtn = IconButton()
        menuBtn.image = Constants.Image.menu
        menuBtn.tintColor = .white
        menuBtn.pulseColor = .white
        menuBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
        return menuBtn
    }()

    internal let settingBtn: IconButton = {
        let settingBtn = IconButton()
        settingBtn.image = Constants.Image.setting
        settingBtn.tintColor = .white
        settingBtn.pulseColor = .white
        settingBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
        return settingBtn
    }()

    internal let flashBtn: UIButton = {
        let flashBtn = UIButton(type: .system)
        flashBtn.tintColor = .white
        flashBtn.setImage(Constants.Image.flashOn, for: .normal)
        flashBtn.translatesAutoresizingMaskIntoConstraints = false
        flashBtn.addShadow(direction: .bottom)
        return flashBtn
    }()

    // label
    internal let qrInfoLbl: UILabel = {
        let qrInfoLbl = UILabel()
        qrInfoLbl.isHiddenWithAlphaAnimation = 0.0
        qrInfoLbl.textAlignment = .center
        qrInfoLbl.numberOfLines = 0
        qrInfoLbl.font = Font.boldSystemFont(ofSize: 15)
        qrInfoLbl.textColor = Color.darkText.primary
        qrInfoLbl.backgroundColor = .white
        qrInfoLbl.sizeToFit()
        qrInfoLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        qrInfoLbl.addShadow(direction: .bottom)
        qrInfoLbl.roundRadius = 2
        return qrInfoLbl
    }()

    internal let scanInfoLbl: UILabel = {
        let scanInfoLbl = UILabel()
        scanInfoLbl.isHiddenWithAlphaAnimation = 0.0
        scanInfoLbl.textAlignment = .center
        scanInfoLbl.numberOfLines = 0
        scanInfoLbl.font = Font.boldSystemFont(ofSize: 15)
        scanInfoLbl.textColor = Color.darkText.primary
        scanInfoLbl.backgroundColor = .white
        scanInfoLbl.sizeToFit()
        scanInfoLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        scanInfoLbl.addShadow(direction: .bottom)
        scanInfoLbl.roundRadius = 2
        return scanInfoLbl
    }()

    private var scanViewType: ScanViewType

    internal var scanInfoView: UIView?

    private var scanCode: String = "" //スキャンタイミング時に以前のQRと照らし合わせるための
    private var scanFlag = true

    internal init(scanType: ScanViewType) {
        scanViewType = scanType
        super.init(frame: .zero)

        setSubViews()
    }

    // MARK: - Default
//    override internal init(frame: CGRect) {
//        super.init(frame: .zero)
//
//    }

    private func setInfoView(scanType: ScanViewType) {
        switch scanType {
        case .home:
            scanInfoView = ScanInfoView(isCodeEnable: false)

        case .list:
            scanInfoView = ScanInfoList()

        case .manage:
            scanInfoView = nil
        }
    }

    private func setSubViews() {
        addSubview(scanPreviewView)
        addSubview(scanBtn)
        addSubview(flashBtn)
        addSubview(profileBtn)
        addSubview(menuBtn)
        addSubview(settingBtn)
        addSubview(qrInfoLbl)
        addSubview(scanInfoLbl)
        setInfoView(scanType: scanViewType)
        if let scanInfoView = scanInfoView {
            addSubview(scanInfoView)
        }
    }

    internal func update(scanType: ScanViewType) {
        scanViewType = scanType
        scanInfoView?.removeFromSuperview()
        resetConstraints()
        setInfoView(scanType: scanType)
        if let scanInfoView = scanInfoView {
            addSubview(scanInfoView)
        }
        setNeedsUpdateConstraints()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func updateConstraints() {
        super.updateConstraints()
        flashBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5 + safeAreaInsets.top)
            make.left.equalTo(28)
            make.width.height.equalTo(35)
        }
        profileBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.flashBtn.snp_centerYWithinMargins)//Safe
            make.right.equalTo(-27)
            make.width.height.equalTo(32)
        }
        scanInfoLbl.snp.makeConstraints { make in
            make.bottom.equalTo(self.scanBtn.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        scanBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10 - safeAreaInsets.bottom)
            make.width.height.equalTo(70)
        }

        switch scanViewType.showType {
        case .default:
            scanPreviewView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                make.bottom.equalToSuperview().multipliedBy(0.45)
            }
            qrInfoLbl.snp.makeConstraints { make in
                make.bottom.equalTo(scanPreviewView.snp.bottom).offset(-15)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
            }
            menuBtn.snp.makeConstraints { make in
                make.centerY.equalTo(scanBtn.snp.centerY)
                make.left.equalTo(scanBtn.snp.right).offset(40)
                make.width.height.equalTo(40)
            }
            settingBtn.snp.makeConstraints { make in
                make.centerY.equalTo(scanBtn.snp.centerY)
                make.right.equalTo(scanBtn.snp.left).offset(-42)
                make.width.height.equalTo(40)
            }
            scanInfoView?.snp.makeConstraints { make in
                make.top.equalTo(scanPreviewView.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalTo(scanBtn.snp.top).offset(-5)
            }

        case .remove:
            qrInfoLbl.snp.makeConstraints { make in
                make.bottom.equalTo(scanInfoLbl.snp.top).offset(-5)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
            }
            scanPreviewView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
    }

    private func resetConstraints() {
        scanPreviewView.snp.removeConstraints()
        qrInfoLbl.snp.removeConstraints()
        menuBtn.snp.removeConstraints()
        settingBtn.snp.removeConstraints()
        if let scanInfoView = scanInfoView {
            scanInfoView.snp.removeConstraints()
        }
    }

    override internal func layoutSubviews() {
        switch scanViewType {
        case .list, .home:
            settingBtn.isHidden = false
            menuBtn.isHidden = false

        case .manage:
            settingBtn.isHidden = true
            menuBtn.isHidden = true
        }
    }

    private func convertRectOfInterest(rect: CGRect) -> CGRect {
        let screenRect = self.frame
        let screenWidth = screenRect.width
        let screenHeight = screenRect.height
        let newX = 1 / (screenWidth / rect.minX)
        let newY = 1 / (screenHeight / rect.minY)
        let newWidth = 1 / (screenWidth / rect.width)
        let newHeight = 1 / (screenHeight / rect.height)
        return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
    }

    // MARK: - Action

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}

// MARK: - Internal Function
extension ScanView {
    internal func scanerSetting(scaner: QRCodeReader, _ find: @escaping (QRCodeReaderResult) -> Void, _ fail: @escaping () -> Void) {
        let widthRect = 0.5
        let heightRect = widthRect * (Double(UIScreen.main.bounds.width) / Double(UIScreen.main.bounds.height * ((self.scanViewType == .home) ? 0.45 : 1.0)))

        let scanViewBuild = QRCodeReaderViewControllerBuilder { build in
            build.reader = scaner
            build.showTorchButton = false
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.handleOrientationChange = true
            build.rectOfInterest = CGRect(x: (1.0 - widthRect) / 2.0, y: (1.0 - heightRect) / ((self.scanViewType == .home) ? 2.0 : 4.0), width: widthRect, height: heightRect)
            //            build.rectOfInterest = convertRectOfInterest(rect: CGRect(x: 0.9, y: 0.9, width: 100, height: 100))
            build.preferredStatusBarStyle = .default
        }
        self.scanPreviewView.setupComponents(with: scanViewBuild)
        scaner.didFindCode = { result in
            if self.scanFlag {
                self.scanFlag = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.scanFlag = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.scanPreviewView.overlayView?.setState(.normal)
                }

                if result.value != self.scanCode {
                    self.scanCode = result.value
                    Sound.tone(mode: .x3dtouch2)
                    self.scanPreviewView.overlayView?.setState(.valid)
                    find(result)
                } else {
                    self.scanPreviewView.overlayView?.setState(.valid)
                }
            }
        }
        scaner.didFailDecoding = { () in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.scanPreviewView.overlayView?.setState(.normal)
            }
            Sound.tone(mode: .fail)
            self.scanPreviewView.overlayView?.setState(.wrong)
            fail()
        }

        scaner.stopScanningWhenCodeIsFound = false
        scaner.startScanning()
    }

    internal func previewQrInfo(msg: String) {
        self.qrInfoLbl.text = msg
        self.qrInfoLbl.alpha = msg.isEmpty ? 0.0 : 1.0
        if msg.isEmpty {
            self.scanCode = msg //スキャン情報保持を上書き
        }
    }

    internal func previewScanInfo(msg: String) {
        self.scanInfoLbl.text = msg
        self.scanInfoLbl.alpha = msg.isEmpty ? 0.0 : 1.0
    }
}
