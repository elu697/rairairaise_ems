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
    let codeTxf = TextField()
    let nameTxf = TextField()
    let adminTxf = TextField()
    let userTxf = TextField()
    let placeTxf = TextField()
    let numberTxf = TextField()

    private let lostTitleLbl = UILabel()
    let lostSwitch = Switch(state: .off, size: .custom(width: 40, height: 30))
    private let discardTitleLbl = UILabel()
    let discardSwitch = Switch(state: .off, size: .custom(width: 40, height: 30))

    private var assetData: Asset?

    var isEditing: Bool {
        set {
            nameTxf.isEnabled = newValue
            adminTxf.isEnabled = newValue
            userTxf.isEnabled = newValue
            placeTxf.isEnabled = newValue
            numberTxf.isEnabled = newValue
            lostSwitch.button.isEnabled = newValue
            discardSwitch.button.isEnabled = newValue
        }
        get {
            adminTxf.isEnabled
        }
    }

    var isCodeEditing: Bool {
        set {
            codeTxf.isEnabled = newValue
        }
        get {
            codeTxf.isEnabled
        }
    }

    // MARK: - Default
    internal init() {
        super.init(frame: .zero)
//        self.backgroundColor = .lightGray
        addSubview(codeTxf)
        addSubview(nameTxf)
        addSubview(adminTxf)
        addSubview(userTxf)
        addSubview(placeTxf)
        addSubview(lostTitleLbl)
        addSubview(lostSwitch)
        addSubview(discardTitleLbl)
        addSubview(discardSwitch)
        addSubview(numberTxf)

        isEditing = false
        isCodeEditing = false

        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        componentSetting()

        backgroundColor = .white
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        codeTxf.snp.makeConstraints { make in
            make.top.equalTo(19)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        nameTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf)
            make.left.equalTo(self.codeTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        adminTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf.snp.bottom).offset(19)
            make.left.equalTo(20)
            make.right.equalTo(self.snp.centerX).offset(-10)
        }

        userTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf)
            make.left.equalTo(self.adminTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        placeTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(19)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.25)
        }

        numberTxf.snp.makeConstraints { make in
            make.top.equalTo(self.placeTxf.snp.top)
            make.left.equalTo(self.placeTxf.snp.right).offset(20)
            make.width.equalToSuperview().multipliedBy(0.17)
        }

        lostTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(19)
            make.left.equalTo(self.numberTxf.snp.right).offset(20)
            make.width.equalTo(150)
        }

        lostSwitch.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.lostTitleLbl)
        }

        discardTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl)
            make.left.equalTo(self.lostSwitch.snp.right).offset(20)
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
    private func componentSetting() {
        codeTxf.placeholder = "資産コード"
        nameTxf.placeholder = "資産名"
        adminTxf.placeholder = "管理者"
        userTxf.placeholder = "使用者"
        placeTxf.placeholder = "管理場所"
        numberTxf.placeholder = "数量"
        numberTxf.keyboardType = .numberPad

        lostTitleLbl.text = "紛失"
        lostTitleLbl.font = .systemFont(ofSize: 13)
        lostTitleLbl.textColor = Color.lightGray
        lostSwitch.buttonOffColor = Color.gray
        lostSwitch.buttonOnColor = Color.red.accent3
        lostSwitch.trackOffColor = Color.lightGray
        lostSwitch.trackOnColor = Color.red.accent2

        discardTitleLbl.text = "廃棄"
        discardTitleLbl.font = .systemFont(ofSize: 13)
        discardTitleLbl.textColor = Color.lightGray
        discardSwitch.buttonOffColor = Color.gray
        discardSwitch.buttonOnColor = Color.red.accent3
        discardSwitch.trackOffColor = Color.lightGray
        discardSwitch.trackOnColor = Color.red.accent2
    }

    // MARK: - Function
    func setAssetData(data: Asset) {
        assetData = data
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
