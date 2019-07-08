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
    let flashBtn = UIButton(type: .system)
    let infoLbl = UILabel()
    let scanCountLbl = UILabel()

    //MARK: - Default
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(self.scanPreviewView)
        self.addSubview(self.scanBtn)
        self.addSubview(self.flashBtn)
        self.addSubview(self.profileBtn)
        self.addSubview(self.menuBtn)
        self.addSubview(self.settingBtn)
        self.addSubview(self.infoLbl)
        self.addSubview(self.scanCountLbl)
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
        self.flashBtnLayoutSetting()
        self.infoLblLayoutSetting()
        self.scanCountLblLayoutSetting()
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
        self.scanBtn.tintColor = .white
        self.scanBtn.setImage(Constants.image.qr, for: .normal)
        self.scanBtn.setBackgroundColor(color: .clear, forState: .normal)
        self.scanBtn.contentMode = .scaleAspectFit
        self.scanBtn.contentHorizontalAlignment = .fill
        self.scanBtn.contentVerticalAlignment = .fill
        self.scanBtn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.addShadow(direction: .bottom, radius: 1, color: .black, opacity: 1)
    }
    
    private func flashBtnLayoutSetting() {
        self.flashBtn.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(28)
            make.width.height.equalTo(35)
        }
        
        self.flashBtn.tintColor = .white
        self.flashBtn.setImage(Constants.image.flashOn, for: .normal)
        self.flashBtn.translatesAutoresizingMaskIntoConstraints = false
        self.flashBtn.addShadow(direction: .bottom)
    }

    private func profileBtnLayoutSetting() {
        self.profileBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.flashBtn.snp_centerYWithinMargins)//Safe
            make.right.equalTo(-27)
            make.width.height.equalTo(32)
        }

        self.profileBtn.image = Constants.image.user
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

        self.menuBtn.image = Constants.image.menu
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

        self.settingBtn.image = Constants.image.setting
        self.settingBtn.tintColor = .white
        self.settingBtn.pulseColor = .white
        self.settingBtn.addShadow(direction: .bottom, radius: 2, color: .black, opacity: 0.5)
    }
    
    private func infoLblLayoutSetting(){
        self.infoLbl.snp.makeConstraints { (make) in
//            make.top.equalTo(self.scanPreviewView.overlayView!.snp.bottom).offset(20)//safe
            make.top.equalTo(self.scanBtn.snp.top).offset(-320)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5).offset(50)
            make.height.equalTo(100)
        }
        self.infoLbl.backgroundColor = .white
        self.infoLbl.addShadow(direction: .bottom)
        self.infoLbl.roundRadius = 20
    }
    
    private func scanCountLblLayoutSetting(){
        self.scanCountLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.scanBtn.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.5).offset(100)
        }
        self.scanCountLbl.backgroundColor = .white
        self.scanCountLbl.addShadow(direction: .bottom)
        self.scanCountLbl.roundRadius = 20
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
