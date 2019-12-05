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
    internal let searchBar: UISearchBar
    internal let pickerView: PickerView

    internal var isEmpty = true {
        didSet {
            setNeedsUpdateConstraints()
        }
    }

    override internal init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        emptyLabel = UILabel(frame: .zero)
        searchBar = UISearchBar(frame: .zero)
        pickerView = PickerView(frame: .zero)
        super.init(frame: .zero)

        searchBar.searchBarStyle = .minimal

        tableView.tableFooterView = UIView()

        addToolBar()

        emptyLabel.text = "データが存在していません"
        emptyLabel.textColor = .gray
        addSubview(tableView)
        addSubview(emptyLabel)
        addSubview(searchBar)
        addSubview(pickerView)
    }
    private func addToolBar() {
        let toolBar = UIToolbar()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        searchBar.inputAccessoryView = toolBar
    }

    @objc func donePressed() {
        endEditing(true)
    }

    override internal func updateConstraints() {
        super.updateConstraints()
        pickerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(120)
            make.leading.equalToSuperview()
            make.height.equalTo(searchBar.snp.height)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.top)
            make.leading.equalTo(pickerView.snp.trailing)
            make.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.bottom.equalToSuperview()
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
