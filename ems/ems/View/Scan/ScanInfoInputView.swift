//
//  ScanInfoView.swift
//  ems
//
//  Created by El You on 2019/08/22.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal class ScanInfoInputView: UIView {
    internal let codeTxf = TextField()
    internal let nameTxf = TextField()
    internal let adminTxf = TextField()
    internal let userTxf = TextField()
    internal let placeTxf = TextField()

    private let lostTitleLbl = UILabel()
    internal let lostSwitch = Switch(state: .off, size: .custom(width: 40, height: 30))
    private let discardTitleLbl = UILabel()
    internal let discardSwitch = Switch(state: .off, size: .custom(width: 40, height: 30))

    private var assetData: Assets?

    // MARK: - Default
    internal init(isCodeEnable: Bool) {
        super.init(frame: .zero)
//        self.backgroundColor = .lightGray
        self.addSubview(self.codeTxf)
        self.addSubview(self.nameTxf)
        self.addSubview(self.adminTxf)
        self.addSubview(self.userTxf)
        self.addSubview(self.placeTxf)
        self.addSubview(self.lostTitleLbl)
        self.addSubview(self.lostSwitch)
        self.addSubview(self.discardTitleLbl)
        self.addSubview(self.discardSwitch)

        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        componentSetting(isCodeEnable: isCodeEnable)

        backgroundColor = .white
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        codeTxf.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        nameTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf)
            make.left.equalTo(self.codeTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        adminTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(self.snp.centerX).offset(-10)
        }

        userTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf)
            make.left.equalTo(self.adminTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        placeTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        lostTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(20)
            make.left.equalTo(self.placeTxf.snp.right).offset(40)
            make.width.equalTo(150)
        }

        lostSwitch.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.lostTitleLbl)
        }

        discardTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl)
            make.left.equalTo(self.lostSwitch.snp.right).offset(30)
            make.width.equalTo(150)
        }

        discardSwitch.snp.makeConstraints { make in
            make.top.equalTo(self.discardTitleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.discardTitleLbl)
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Layout
    private func componentSetting(isCodeEnable: Bool) {
        self.codeTxf.placeholder = "資産コード"
        self.codeTxf.text = self.assetData?.code
        self.codeTxf.isEnabled = isCodeEnable

        self.nameTxf.placeholder = "資産名"
        self.nameTxf.text = self.assetData?.name
        self.nameTxf.isEnabled = true

        self.adminTxf.placeholder = "管理者"
        self.adminTxf.text = self.assetData?.admin
        self.adminTxf.isEnabled = true

        self.userTxf.placeholder = "使用者"
        self.userTxf.text = self.assetData?.user
        self.userTxf.isEnabled = true

        self.placeTxf.placeholder = "管理場所"
        self.placeTxf.text = self.assetData?.location
        self.placeTxf.isEnabled = true

        self.lostTitleLbl.text = "紛失"
        self.lostTitleLbl.font = .systemFont(ofSize: 13)
        self.lostTitleLbl.textColor = Color.lightGray
        self.lostSwitch.buttonOffColor = Color.gray
        self.lostSwitch.buttonOnColor = Color.red.accent3
        self.lostSwitch.trackOffColor = Color.lightGray
        self.lostSwitch.trackOnColor = Color.red.accent2
        self.lostSwitch.isOn = self.assetData?.loss ?? false

        self.discardTitleLbl.text = "廃棄"
        self.discardTitleLbl.font = .systemFont(ofSize: 13)
        self.discardTitleLbl.textColor = Color.lightGray
        self.discardSwitch.buttonOffColor = Color.gray
        self.discardSwitch.buttonOnColor = Color.red.accent3
        self.discardSwitch.trackOffColor = Color.lightGray
        self.discardSwitch.trackOnColor = Color.red.accent2
        self.discardSwitch.isOn = self.assetData?.discard ?? false
    }

    // MARK: - Function
    internal func setAssetData(data: Assets) {
        self.assetData = data
        UIView.animate(withDuration: 1.0) {
            self.codeTxf.text = self.assetData?.code
            self.nameTxf.text = self.assetData?.name
            self.adminTxf.text = self.assetData?.admin
            self.userTxf.text = self.assetData?.user
            self.placeTxf.text = self.assetData?.location
            self.lostSwitch.isOn = self.assetData?.loss ?? false
            self.discardSwitch.isOn = self.assetData?.discard ?? false
        }
    }
}
