//
//  GoogleDriveView.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/07.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import GoogleSignIn
import SnapKit
import UIKit

class GoogleDriveView: UIView {
    let signInBtn: GIDSignInButton
    let listBtn: UIButton

    override init(frame: CGRect) {
        signInBtn = GIDSignInButton()
        listBtn = UIButton(type: .system)
        super.init(frame: .zero)

        backgroundColor = .white

        listBtn.titleLabel?.text = "List"
        listBtn.backgroundColor = .gray
        listBtn.sizeToFit()

        addSubview(signInBtn)
        addSubview(listBtn)
    }

    override func updateConstraints() {
        super.updateConstraints()

        signInBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        listBtn.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
