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
    private static var assets: [Assets] = []
    private var checkList: [String: Bool] = [:]

    override internal func loadView() {
        view = ScanAssetCheckList()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as? ScanAssetCheckList else { return }
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        view.tableView.isEditing = false
        view.tableView.dataSource = self
        view.tableView.delegate = self
        if !ScanAssetCheckListViewController.assets.isEmpty {
            view.tableView.reloadData()
            view.isEmpty = ScanAssetCheckListViewController.assets.isEmpty
        }
        view.setNeedsUpdateConstraints()
    }

    internal func fetch(value: String, _ err: @escaping (DBStore.DBStoreError) -> Void) {
        SVProgressHUD.show()
        print("fetch")
        DBStore.share.search(field: .location, value: value) { assets, error in
            print("fetch complete")
            guard let assets = assets else {
                DispatchQueue.main.async {
                    print("fetch error")
                    err(error != nil ? .failed : .notFound)
                    SVProgressHUD.dismiss()
                }
                return
            }
            ScanAssetCheckListViewController.assets = assets
            for item in assets {
                self.checkList[item.code] = false
            }
            print("fetch: \(assets.count) items")
            DispatchQueue.main.async {
                guard let view = self.view as? ScanAssetCheckList else { return }
                view.isEmpty = ScanAssetCheckListViewController.assets.isEmpty
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
        return ScanAssetCheckListViewController.assets.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = ScanAssetCheckListViewController.assets[indexPath.row].name ?? "名前が登録されていません"
        if let isChecked = checkList[ScanAssetCheckListViewController.assets[indexPath.row].code], isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Leading & .normal") { _, _, boolValue in
            boolValue(true) // pass true if you want the handler to allow the action
            print("Leading Action style .normal")
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

extension ScanAssetCheckListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className): tap")

        let vc = AssetCheckViewController()
        vc.fetch(value: ScanAssetCheckListViewController.assets[indexPath.row].code) { _ in
            self.pushNewNavigationController(rootViewController: vc)
        }
    }
}
