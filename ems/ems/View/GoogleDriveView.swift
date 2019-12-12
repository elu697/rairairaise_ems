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

internal class GoogleDriveView: UIView {
    internal let signInBtn: GIDSignInButton
    internal let listBtn: UIButton
    internal let emptyLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "選択できるファイルがありません"
        lbl.sizeToFit()
        return lbl
    }()

    override internal init(frame: CGRect) {
        signInBtn = GIDSignInButton()
        listBtn = UIButton(type: .system)
        super.init(frame: .zero)

        backgroundColor = .white

        listBtn.titleLabel?.text = "List"
        listBtn.backgroundColor = .gray
        listBtn.sizeToFit()

        addSubview(signInBtn)
        addSubview(listBtn)
        addSubview(emptyLbl)
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        signInBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        listBtn.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }

        emptyLbl.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
