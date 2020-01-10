//
//  MenuView.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import SnapKit
import UIKit

internal class MenuView: UIView {
    // MARK: - Property
    internal let tableView: UITableView
    // MARK: - Default
    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: .zero)

        tableView.tableFooterView = UIView()

        addSubview(tableView)
    }

    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override internal func layoutSubviews() {
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }

    // MARK: - Function
    // MARK: - Action
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
