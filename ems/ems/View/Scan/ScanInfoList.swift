//
//  ScanInfoList.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/27.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

class ScanInfoList: UIView {
    internal let tableView: UITableView
    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: .zero)

        addSubview(tableView)
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
