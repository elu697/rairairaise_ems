//
//  ScanInfoList.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/27.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

internal class ScanAssetCheckList: UIView {
    internal let tableView: UITableView
    internal let emptyLabel: UILabel

    var isEmpty = true {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        emptyLabel = UILabel(frame: .zero)
        super.init(frame: .zero)

        tableView.tableFooterView = UIView()

        emptyLabel.text = "データが存在していません"
        addSubview(tableView)
        addSubview(emptyLabel)
    }

    override internal func updateConstraints() {
        super.updateConstraints()
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
        tableView.isHidden = isEmpty
        emptyLabel.isHidden = !isEmpty
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
