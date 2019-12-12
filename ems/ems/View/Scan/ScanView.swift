//
//  ScanView.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import Foundation
import GoogleSignIn
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
        button.roundRadius = 33
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

    internal let updateBtn: UIButton = {
        let btn = UIButton()
//        btn.addTarget(self, action: #selector(tapedTryButton), for: .touchUpInside)
        btn.setTitle("更新", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("更新", for: .highlighted)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.gray.cgColor
        return btn
    }()

    internal var contentView = UIView()

    private var scanCode: String = "" //スキャンタイミング時に以前のQRと照らし合わせるための

    internal init(scaner: QRCodeReader) {
        super.init(frame: .zero)

        scanPreviewView.setupComponents(with: scanViewBuild(scaner: scaner))
        setSubViews()
    }

    // MARK: - Default

    private func setSubViews() {
        addSubview(scanPreviewView)
        addSubview(scanBtn)
        addSubview(flashBtn)
        addSubview(menuBtn)
        addSubview(settingBtn)
        addSubview(qrInfoLbl)
        addSubview(scanInfoLbl)
        addSubview(contentView)
        addSubview(updateBtn)
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
        scanInfoLbl.snp.makeConstraints { make in
            make.bottom.equalTo(self.scanBtn.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        scanBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10 - safeAreaInsets.bottom)
            make.width.height.equalTo(66)
        }

        //switch scanViewType.showType {
        //case .default:
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
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scanPreviewView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(scanBtn.snp.top).offset(-5)
        }

        updateBtn.snp.makeConstraints { make in
            make.bottom.equalTo(scanBtn.snp.top).inset(-22)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }

        /*case .remove:
            qrInfoLbl.snp.makeConstraints { make in
                make.bottom.equalTo(scanInfoLbl.snp.top).offset(-5)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
            }
            scanPreviewView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalToSuperview()
            }
        }*/
    }

    private func resetConstraints() {
        scanPreviewView.snp.removeConstraints()
        qrInfoLbl.snp.removeConstraints()
        menuBtn.snp.removeConstraints()
        settingBtn.snp.removeConstraints()
        contentView.snp.removeConstraints()
    }

    override internal func layoutSubviews() {
        //switch scanViewType {
        //case .list, .home:
        settingBtn.isHidden = false
        //menuBtn.isHidden = false

        /*case .manage:
            settingBtn.isHidden = true
            menuBtn.isHidden = true
        }*/
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

    private func scanViewBuild(scaner: QRCodeReader) -> QRCodeReaderViewControllerBuilder {
        let widthRect = 0.5
        let heightRect = widthRect * (Double(UIScreen.main.bounds.width) / Double(UIScreen.main.bounds.height * 0.45))

        return QRCodeReaderViewControllerBuilder { build in
            build.reader = scaner
            build.showTorchButton = false
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.handleOrientationChange = true
            build.rectOfInterest = CGRect(x: (1.0 - widthRect) / 2.0, y: (1.0 - heightRect) / 2.0, width: widthRect, height: heightRect)
            build.preferredStatusBarStyle = .default
        }
    }
    // MARK: - Action
}

// MARK: - Internal Function
extension ScanView {
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
