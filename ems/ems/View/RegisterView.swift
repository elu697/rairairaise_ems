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
    internal var registBtn = UIButton(type: .system)

    internal init() {
        super.init(frame: .zero)

        registBtn.backgroundColor = .blue

        addSubview(content)
        addSubview(registBtn)
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        content.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().inset(64)
            make.bottom.equalToSuperview()
        }
        registBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
