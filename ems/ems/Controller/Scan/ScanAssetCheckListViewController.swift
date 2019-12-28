//
//  ScanInfoListViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Material
import PromiseKit
import SVProgressHUD
import UIKit

internal class ScanAssetCheckListViewController: UIViewController {
    private static var assets: [Asset] = []
    private var checkList: [String: Bool] = [:]
    private static var searchType: Assets.Field?

    private var item: [Assets.Field] = [.code, .admin, .user, .name, .location]

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
        view.pickerView.delegate = self
        view.pickerView.dataSource = self
//        view.pickerView.value = ScanAssetCheckListViewController.searchType.name
        view.pickerView.placeHolder = "検索項目"
        view.searchBar.delegate = self
        view.setNeedsUpdateConstraints()
    }

    internal func fetch(value: String) -> Promise<[Asset]> {
        guard let searchType = ScanAssetCheckListViewController.searchType else {
            SVProgressHUD.showError(withStatus: "検索項目を選択してください")
            return Promise<[Asset]>(error: DBStoreError.inputFailed)
        }
        SVProgressHUD.show()
        return DBStore.shared.search(field: searchType, value: value).then { assets -> Promise<[Asset]> in
            SVProgressHUD.dismiss()
            ScanAssetCheckListViewController.assets = assets
            for item in assets {
                self.checkList[item.code ?? ""] = false
            }
            DispatchQueue.main.async {
                guard let view = self.view as? ScanAssetCheckList else { return }
                view.isEmpty = ScanAssetCheckListViewController.assets.isEmpty
                view.tableView.reloadData()
            }
            return Promise<[Asset]>.value(assets)
        }
        /*DBStore.share.search(field: searchType, value: value).done { assets, error in
            SVProgressHUD.dismiss()
            guard let assets = assets else {
                DispatchQueue.main.async {
                    err(error != nil ? .failed : .notFound)
                }
                return
            }
            ScanAssetCheckListViewController.assets = assets
            for item in assets {
                self.checkList[item.code] = false
            }
            DispatchQueue.main.async {
                guard let view = self.view as? ScanAssetCheckList else { return }
                view.isEmpty = ScanAssetCheckListViewController.assets.isEmpty
                view.tableView.reloadData()
            }
        }*/
    }

    internal func check(code: String) {
        checkList[code] = true
        guard let view = view as? ScanAssetCheckList else { return }
        view.tableView.reloadData()
    }
}

// MARK: UITableViewDataSorce
extension ScanAssetCheckListViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScanAssetCheckListViewController.assets.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = ScanAssetCheckListViewController.assets[indexPath.row].name ?? "名前が登録されていません"
        if let isChecked = checkList[ScanAssetCheckListViewController.assets[indexPath.row].code ?? ""], isChecked {
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
        let contextItem = UIContextualAction(style: .normal, title: "削除") { _, _, boolValue in
            boolValue(true) // pass true if you want the handler to allow the action
            let code = ScanAssetCheckListViewController.assets[indexPath.row].code
            SVProgressHUD.show()
            /*DBStore.share.delete(code: code, completion: { error in
                SVProgressHUD.dismiss()
                if error != nil {
                    SVProgressHUD.showError(withStatus: "削除に失敗しました")
                } else {
                    SVProgressHUD.showSuccess(withStatus: "削除に成功しました")
                    ScanAssetCheckListViewController.assets.remove(at: indexPath.row)
                    guard let view = self.view as? ScanAssetCheckList else { return }
                    view.isEmpty = ScanAssetCheckListViewController.assets.isEmpty
                    tableView.reloadData()
                }
            }
            )*/
        }
        contextItem.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

// MARK: UITableViewDelegate
extension ScanAssetCheckListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className): tap")

        let vc = AssetCheckViewController()
        /*vc.fetch(value: ScanAssetCheckListViewController.assets[indexPath.row].code) { _ in
            self.pushNewNavigationController(rootViewController: vc)
        }*/
    }
}

// MARK: PickerViewDelegate
extension ScanAssetCheckListViewController: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let view = view as? ScanAssetCheckList else { return }
        ScanAssetCheckListViewController.searchType = item[row]
        view.pickerView.value = item[row].name
    }
}

// MARK: PickerViewDataSource
extension ScanAssetCheckListViewController: UIPickerViewDataSource {
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return item.count
    }

    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return item[row].name
    }
}

extension ScanAssetCheckListViewController: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let value = searchBar.text else { return }
        /*fetch(value: value) { error in
            SVProgressHUD.showError(withStatus: error.descript)
        }*/
    }
}
