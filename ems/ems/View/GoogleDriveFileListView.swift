//
//  GoogleDriveView.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/07.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Material
import SnapKit
import UIKit

internal class GoogleDriveFileListView: UIView {
    internal let tableView: UITableView
    internal let addBtn: FABButton
    internal let emptyLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "選択できるファイルがありません"
        lbl.sizeToFit()
        return lbl
    }()

    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        addBtn = FABButton(image: Icon.cm.add, tintColor: .white)
        super.init(frame: .zero)

        backgroundColor = .white

        addBtn.backgroundColor = .red

        addSubview(tableView)
        addSubview(emptyLbl)
    }

    override internal func updateConstraints() {
        super.updateConstraints()

        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
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
