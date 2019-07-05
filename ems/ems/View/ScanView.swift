//
//  ScanView.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Material

class ScanView: UIView {
    //MARK: - Property
    let scanPreviewView = QRCodeReaderView()
    let scanBtn = UIButton(type: .system)
    let profileBtn = IconButton()
    let menuBtn = IconButton()
    let settingBtn = IconButton()

    //MARK: - Default
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(self.scanPreviewView)
        self.addSubview(self.scanBtn)
        self.addSubview(self.profileBtn)
        self.addSubview(self.menuBtn)
        self.addSubview(self.settingBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.scanPreviewViewLayoutSetting()
        self.scanBtnLayoutSetting()
        self.profileBtnLayoutSetting()
        self.menuBtnLayoutSetting()
        self.settingBtnLayoutSetting()
    }

    //MARK: - Layout
    private func scanPreviewViewLayoutSetting() {
        self.scanPreviewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func scanBtnLayoutSetting() {
        self.scanBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-50)
            make.width.height.equalTo(70)
        }

        self.scanBtn.roundRadius = 35
        self.scanBtn.borderWidth = 5
        self.scanBtn.borderColor = .gray
        self.scanBtn.tintColor = .gray
        self.scanBtn.setImage(R.image.cropSimpleFilled(), for: .normal)
        self.scanBtn.setBackgroundColor(color: .clear, forState: .normal)
        self.addShadow(direction: .bottom, radius: 1, color: .black, opacity: 1)
    }

    private func profileBtnLayoutSetting() {
        self.profileBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo((self.scanPreviewView.toggleTorchButton?.snp.centerY)!)//Safe
            make.right.equalTo(-27)
            make.width.height.equalTo(32)
        }

        self.profileBtn.image = R.image.profileSimpleFilled()
        self.profileBtn.tintColor = .white
        self.profileBtn.pulseColor = .white
        self.profileBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }

    private func menuBtnLayoutSetting() {
        self.menuBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.scanBtn.snp.centerY)
            make.left.equalTo(self.scanBtn.snp.right).offset(30)
            make.width.height.equalTo(40)
        }

        self.menuBtn.image = R.image.menuSimpleFilled()
        self.menuBtn.tintColor = .white
        self.menuBtn.pulseColor = .white
        self.menuBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }

    private func settingBtnLayoutSetting() {
        self.settingBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.scanBtn.snp.centerY)
            make.right.equalTo(self.scanBtn.snp.left).offset(-32)
            make.width.height.equalTo(40)
        }

        self.settingBtn.image = R.image.settingSimpleFilled()
        self.settingBtn.tintColor = .white
        self.settingBtn.pulseColor = .white
        self.settingBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }
    //MARK: - Function
    //MARK: - Action

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
