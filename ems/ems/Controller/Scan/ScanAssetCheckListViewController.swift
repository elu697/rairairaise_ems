//
//  ScanInfoListViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

internal class ScanAssetCheckListViewController: UIViewController {
    private var assets: [Assets] = []
    private var checkList: [String: Bool] = [:]

    override internal func loadView() {
        view = ScanAssetCheckList()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as? ScanAssetCheckList else { return }
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        view.tableView.dataSource = self
        view.setNeedsUpdateConstraints()
    }

    internal func fetch(value: String, _ err: @escaping (DBStore.DBStoreError) -> Void) {
        SVProgressHUD.show()
        DBStore.share.search(field: .location, value: value) { assets, error in
            guard let assets = assets else {
                DispatchQueue.main.async {
                    err(error != nil ? .failed : .notFound)
                    SVProgressHUD.dismiss()
                }
                return
            }
            self.assets = assets
            for item in assets {
                self.checkList[item.code] = false
            }
            DispatchQueue.main.async {
                guard let view = self.view as? ScanAssetCheckList else { return }
                view.isEmpty = self.assets.isEmpty
                view.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }

    internal func check(code: String) {
        checkList[code] = true
        guard let view = view as? ScanAssetCheckList else { return }
        view.tableView.reloadData()
    }
}

extension ScanAssetCheckListViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = assets[indexPath.row].name ?? "名前が登録されていません"
        if let isChecked = checkList[assets[indexPath.row].code], isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension ScanAssetCheckListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className): tap")
    }
}
