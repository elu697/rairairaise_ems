//
//  ScanInfoList.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/27.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

class ScanAssetCheckList: UIView {
    internal let tableView: UITableView
    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: .zero)

        addSubview(tableView)
    }

    override func updateConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
