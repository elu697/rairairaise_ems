//
//  RegisterView.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/18.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

internal class RegisterView: UIView {
    internal var content = UIView()

    internal var driveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("GoogleDriveからcsvファイルを選択して登録", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("GoogleDriveからcsvファイルを選択して登録", for: .highlighted)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.layer.addUnderline()
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
//        btn.sizeToFit()
//        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn.layer.cornerRadius = 5.0
//        btn.layer.borderWidth = 1.5
//        btn.layer.borderColor = UIColor.gray.cgColor
        return btn
    }()

    internal var registBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("登録", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("登録", for: .highlighted)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.gray.cgColor
        return btn
    }()

    internal init() {
        super.init(frame: .zero)

        addSubview(content)
        addSubview(registBtn)
        addSubview(driveBtn)
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        content.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(120)
            make.bottom.equalToSuperview()
        }
        registBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(150)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        driveBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalTo(registBtn.snp.top).offset(-40)
        }
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
