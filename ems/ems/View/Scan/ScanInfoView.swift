//
//  ScanInfoView.swift
//  ems
//
//  Created by El You on 2019/08/22.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal class ScanInfoView: UIView {
    private let codeTxf = TextField()
    private let nameTxf = TextField()
    private let adminTxf = TextField()
    private let userTxf = TextField()
    private let placeTxf = TextField()

    private let lostTitleLbl = UILabel()
    private let lostSwitch = Switch(state: .off, size: .custom(width: 60, height: 30))
    private let discardTitleLbl = UILabel()
    private let discardSwitch = Switch(state: .off, size: .custom(width: 60, height: 30))

    private var code = "testcode01"
    private var name = "test name"
    private var admin = "test master"
    private var user = "test user"
    private var place = "test hole"
    private var lostFlag = false
    private var discardFlag = false

    // MARK: - Default
    override internal init(frame: CGRect) {
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

        self.componentSetting()
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func updateConstraints() {
        super.updateConstraints()
        self.codeTxf.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        self.nameTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf)
            make.left.equalTo(self.codeTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        self.adminTxf.snp.makeConstraints { make in
            make.top.equalTo(self.codeTxf.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(self.snp.centerX).offset(-10)
        }

        self.userTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf)
            make.left.equalTo(self.adminTxf.snp.right).offset(20)
            make.right.equalTo(-20)
        }

        self.placeTxf.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.3)
        }

        self.lostTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.adminTxf.snp.bottom).offset(20)
            make.left.equalTo(self.placeTxf.snp.right).offset(40)
            make.width.equalTo(150)
        }

        self.lostSwitch.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.lostTitleLbl)
        }

        self.discardTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(self.lostTitleLbl)
            make.left.equalTo(self.lostSwitch.snp.right).offset(30)
            make.width.equalTo(150)
        }

        self.discardSwitch.snp.makeConstraints { make in
            make.top.equalTo(self.discardTitleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.discardTitleLbl)
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Layout
    private func componentSetting() {
        self.codeTxf.placeholder = "資産コード"
        self.codeTxf.text = self.code
        self.codeTxf.isEnabled = false

        self.nameTxf.placeholder = "資産名"
        self.nameTxf.text = self.name
        self.nameTxf.isEnabled = true

        self.adminTxf.placeholder = "管理者"
        self.adminTxf.text = self.admin
        self.adminTxf.isEnabled = true

        self.userTxf.placeholder = "使用者"
        self.userTxf.text = self.user
        self.userTxf.isEnabled = true

        self.placeTxf.placeholder = "管理場所"
        self.placeTxf.text = self.place
        self.placeTxf.isEnabled = true

        self.lostTitleLbl.text = "紛失"
        self.lostTitleLbl.font = .systemFont(ofSize: 13)
        self.lostTitleLbl.textColor = Color.lightGray
        self.lostSwitch.buttonOffColor = Color.gray
        self.lostSwitch.buttonOnColor = Color.red.accent2
        self.lostSwitch.trackOffColor = Color.lightGray
        self.lostSwitch.trackOnColor = Color.red.accent1
//        self.lostSwitch.isOn = self.lostFlag

        self.discardTitleLbl.text = "廃棄"
        self.discardTitleLbl.font = .systemFont(ofSize: 13)
        self.discardTitleLbl.textColor = Color.lightGray
        self.discardSwitch.buttonOffColor = Color.gray
        self.discardSwitch.buttonOnColor = Color.red.accent2
        self.discardSwitch.trackOffColor = Color.lightGray
        self.discardSwitch.trackOnColor = Color.red.accent1
//        self.discardSwitch.isOn = self.discardFlag
    }
    // MARK: - Function
    // MARK: - Action

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}