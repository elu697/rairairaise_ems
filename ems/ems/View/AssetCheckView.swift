//
//  AssetCheckView.swift
//  ems
//
//  Created by 吉野瑠 on 2019/11/28.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

internal class AssetCheckView: UIView {
    internal var content = ScanInfoInputView(isCodeEnable: false)

    override internal init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .white

        addSubview(content)
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        content.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
