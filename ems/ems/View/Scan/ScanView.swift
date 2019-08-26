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

    internal let scanPreviewView = QRCodeReaderView()
    internal let scanBtn = UIButton(type: .system)
    internal let profileBtn = IconButton()
    internal let menuBtn = IconButton()
    internal let settingBtn = IconButton()
    internal let flashBtn = UIButton(type: .system)
    internal let qrInfoLbl = UILabel()
    internal let scanInfoLbl = UILabel()

    internal let scanInfoView = ScanInfoView()

    private var scanCode: String = "" //スキャンタイミング時に以前のQRと照らし合わせるための
    private var scanFlag = true

    // MARK: - Default
    override internal init(frame: CGRect) {
        super.init(frame: .zero)
        super.layoutSubviews()
        self.addSubview(self.scanInfoView)
        self.addSubview(self.scanPreviewView)
        self.addSubview(self.scanBtn)
        self.addSubview(self.flashBtn)
        self.addSubview(self.profileBtn)
        self.addSubview(self.menuBtn)
        self.addSubview(self.settingBtn)
        self.addSubview(self.qrInfoLbl)
        self.addSubview(self.scanInfoLbl)

        self.scanPreviewViewLayoutSetting()
        self.scanBtnLayoutSetting()
        self.profileBtnLayoutSetting()
        self.menuBtnLayoutSetting()
        self.settingBtnLayoutSetting()
        self.flashBtnLayoutSetting()
        self.qrInfoLblLayoutSetting()
        self.scanInfoLblLayoutSetting()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func updateConstraints() {
        super.updateConstraints()
        self.scanPreviewView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.45)
        }
        //        self.clipsToBounds = true
        self.flashBtn.snp.makeConstraints { make in
            //            make.top.equalTo(50)
            make.top.equalToSuperview().offset(5 + safeAreaInsets.top)
            make.left.equalTo(28)
            make.width.height.equalTo(35)
        }
        self.profileBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.flashBtn.snp_centerYWithinMargins)//Safe
            make.right.equalTo(-27)
            make.width.height.equalTo(32)
        }
        self.qrInfoLbl.snp.makeConstraints { make in
            //            make.top.equalTo(self.scanPreviewView.overlayView!.snp.bottom).offset(20)//safe
            make.bottom.equalTo(self.scanPreviewView.snp.bottom).offset(-5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        self.scanInfoLbl.snp.makeConstraints { make in
            //            make.centerX.equalToSuperview()
            //            make.height.equalTo(40)
            //            make.width.equalToSuperview().multipliedBy(0.5).offset(100)
            make.bottom.equalTo(self.scanBtn.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        self.scanBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10 - safeAreaInsets.bottom)
            make.width.height.equalTo(70)
        }
        self.menuBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.scanBtn.snp.centerY)
            make.left.equalTo(self.scanBtn.snp.right).offset(40)
            make.width.height.equalTo(40)
        }
        self.settingBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.scanBtn.snp.centerY)
            make.right.equalTo(self.scanBtn.snp.left).offset(-42)
            make.width.height.equalTo(40)
        }
        self.scanInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.scanPreviewView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.scanBtn.snp.top).offset(-5)
        }
    }

    override internal func layoutSubviews() {
    }

    // MARK: - Layout
    private func scanPreviewViewLayoutSetting() {
        self.scanPreviewView.backgroundColor = .black
    }

    private func scanBtnLayoutSetting() {
        self.scanBtn.roundRadius = 35
        self.scanBtn.borderWidth = 5
        self.scanBtn.borderColor = .gray
        self.scanBtn.tintColor = .gray
        self.scanBtn.setImage(Constants.Image.qr, for: .normal)
        self.scanBtn.setBackgroundColor(color: .clear, forState: .normal)
        self.scanBtn.contentMode = .scaleAspectFit
        self.scanBtn.contentHorizontalAlignment = .fill
        self.scanBtn.contentVerticalAlignment = .fill
        self.scanBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.addShadow(direction: .bottom, radius: 1, color: .black, opacity: 1)
    }

    private func flashBtnLayoutSetting() {
        self.flashBtn.tintColor = .white
        self.flashBtn.setImage(Constants.Image.flashOn, for: .normal)
        self.flashBtn.translatesAutoresizingMaskIntoConstraints = false
        self.flashBtn.addShadow(direction: .bottom)
    }

    private func profileBtnLayoutSetting() {
        self.profileBtn.image = Constants.Image.user
        self.profileBtn.tintColor = .white
        self.profileBtn.pulseColor = .white
        self.profileBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }

    private func menuBtnLayoutSetting() {
        self.menuBtn.image = Constants.Image.menu
        self.menuBtn.tintColor = .white
        self.menuBtn.pulseColor = .white
        self.menuBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }

    private func settingBtnLayoutSetting() {
        self.settingBtn.image = Constants.Image.setting
        self.settingBtn.tintColor = .white
        self.settingBtn.pulseColor = .white
        self.settingBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }

    private func qrInfoLblLayoutSetting() {
        self.qrInfoLbl.isHiddenWithAlphaAnimation = 0.0
        self.qrInfoLbl.textAlignment = .center
        self.qrInfoLbl.numberOfLines = 0
        self.qrInfoLbl.font = Font.boldSystemFont(ofSize: 15)
        self.qrInfoLbl.textColor = Color.darkText.primary
        self.qrInfoLbl.backgroundColor = .white
        self.qrInfoLbl.sizeToFit()
        self.qrInfoLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.qrInfoLbl.addShadow(direction: .bottom)
        self.qrInfoLbl.roundRadius = 2
    }

    private func scanInfoLblLayoutSetting() {
        self.scanInfoLbl.isHiddenWithAlphaAnimation = 0.0
        self.scanInfoLbl.textAlignment = .center
        self.scanInfoLbl.numberOfLines = 0
        self.scanInfoLbl.font = Font.boldSystemFont(ofSize: 15)
        self.scanInfoLbl.textColor = Color.darkText.primary
        self.scanInfoLbl.backgroundColor = .white
        self.scanInfoLbl.sizeToFit()
        self.scanInfoLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.scanInfoLbl.addShadow(direction: .bottom)
        self.scanInfoLbl.roundRadius = 2
    }

    private func scanInfoViewLayoutSetting() {
    }

    // MARK: - Function
    internal func scanerSetting(scaner: QRCodeReader, _ find: @escaping (QRCodeReaderResult) -> Void, _ fail: @escaping () -> Void) {
        let widthRect = 0.5
        let heightRect = widthRect * (Double(UIScreen.main.bounds.width) / Double(UIScreen.main.bounds.height * 0.45))

        let scanViewBuild = QRCodeReaderViewControllerBuilder { build in
            build.reader = scaner
            build.showTorchButton = false
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.handleOrientationChange = true
            build.rectOfInterest = CGRect(x: (1.0 - widthRect) / 2.0, y: (1.0 - heightRect) / 2.0, width: widthRect, height: heightRect)
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

//    internal func previewAssetInfo(asset: Asset){
//        self.scanInfoView.setAssetData(data: asset)
//    }

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
