//
//  ProfileView.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit

internal class ProfileView: UIView {
    // MARK: - Property
    internal let nowPlace = UILabel(frame: .zero)
    internal let input = UITextField(frame: .zero)

    // MARK: - Default
    internal init() {
        super.init(frame: .zero)
        addSubview(nowPlace)
        addSubview(input)
        updateConstraintsIfNeeded()
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override internal func updateConstraints() {
        super.updateConstraints()

        nowPlace.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(100)
            make.center.equalToSuperview()
        }
        input.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(100)
            make.left.equalTo(nowPlace.snp.right)
            make.centerY.equalToSuperview()
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
    }
    // MARK: - Function
    // MARK: - Action
}
