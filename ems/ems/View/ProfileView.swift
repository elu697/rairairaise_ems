//
//  ProfileView.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal class ProfileView: UIView {
    // MARK: - Property
    internal let inputField: TextField = {
        let text = TextField()
        text.placeholder = "現在地"
        text.isEnabled = true
        return text
    }()

    internal let reloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

    // MARK: - Default
    internal init() {
        super.init(frame: .zero)

        reloadBtn.backgroundColor = .blue

        addSubview(inputField)
        addSubview(reloadBtn)
        updateConstraintsIfNeeded()
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override internal func updateConstraints() {
        super.updateConstraints()

        inputField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
        reloadBtn.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.left.equalTo(inputField.snp.right)
            make.centerY.equalToSuperview()
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: - Function
    // MARK: - Action
}
