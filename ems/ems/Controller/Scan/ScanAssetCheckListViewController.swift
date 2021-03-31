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
    private var models: [Asset] {
        AppDataManager.shared.get(key: DataKey.models.rawValue) as? [Asset] ?? []
    }

    private var searchType: Assets.Field? {
        get {
            AppDataManager.shared.get(key: DataKey.searchType.rawValue) as? Assets.Field
        }
        set(value) {
            AppDataManager.shared.set(key: DataKey.searchType.rawValue, value: value as Any)
        }
    }

    private var query: String? {
        get {
            AppDataManager.shared.get(key: DataKey.query.rawValue) as? String
        }
        set(value) {
            AppDataManager.shared.set(key: DataKey.query.rawValue, value: value as Any)
        }
    }

    private var checkList: [String: Bool] = [:]

    private var item: [Assets.Field] = [.code, .admin, .user, .name, .location]
    private var checkView: ScanAssetCheckList? {
        return view as? ScanAssetCheckList
    }

    private enum DataKey: String {
        case models
        case searchType
        case query
    }

    var isSearched: Bool {
        return !models.isEmpty
    }

    override func loadView() {
        view = ScanAssetCheckList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        checkView?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        checkView?.tableView.isEditing = false
        checkView?.tableView.dataSource = self
        checkView?.tableView.delegate = self

        // 既に取得済みだった場合再読み込み
        if !models.isEmpty {
            checkView?.tableView.reloadData()
            checkView?.isEmpty = models.isEmpty
        }

        checkView?.pickerView.delegate = self
        checkView?.pickerView.dataSource = self
        checkView?.pickerView.placeHolder = "検索項目"
        if searchType == nil {
            searchType = item[0]
        }
        checkView?.pickerView.value = searchType?.name ?? ""
        checkView?.searchBar.delegate = self
        checkView?.searchBar.text = query
        view.setNeedsUpdateConstraints()
    }

    func fetch(value: String) -> Promise<[Asset]> {
        guard let searchType = searchType else {
            SVProgressHUD.showError(withStatus: "検索項目を選択してください")
            return Promise<[Asset]>(error: DBStoreError.inputFailed)
        }

        return DBStore.shared.search(field: searchType, value: value)
    }

    func check(code: String) {
        var model = Asset()
        model.code = code
        model.checkedAt = Date()
        SVProgressHUD.show()
        DBStore.shared.update(model).done {
            self.checkList[code] = true
            DispatchQueue.main.async {
                self.checkView?.tableView.reloadData()
            }
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }
    }
}

// MARK: UITableViewDataSorce
extension ScanAssetCheckListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = models[indexPath.row].name ?? "名前が登録されていません"
        if let isChecked = checkList[models[indexPath.row].code ?? ""], isChecked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "削除") { _, _, boolValue in
            boolValue(true)
            guard let code = self.models[indexPath.row].code else {
                return
            }

            SVProgressHUD.show()
            DBStore.shared.delete(code: code).done {
                SVProgressHUD.showSuccess(withStatus: "削除に成功しました")
                if var value = AppDataManager.shared.get(key: DataKey.models.rawValue) as? [Asset] {
                    value.remove(at: indexPath.row)
                    AppDataManager.shared.set(key: DataKey.models.rawValue, value: value)
                }
                self.checkView?.isEmpty = self.models.isEmpty
                tableView.reloadData()
            }.catch { _ in
                SVProgressHUD.showError(withStatus: "削除に失敗しました")
            }
        }
        contextItem.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
}

// MARK: UITableViewDelegate
extension ScanAssetCheckListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className): tap")

        let vc = AssetCheckViewController()
        SVProgressHUD.show()
        vc.fetch(value: models[indexPath.row].code ?? "").done {
            SVProgressHUD.dismiss()
            self.pushNewNavigationController(rootViewController: vc)
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }
    }
}

// MARK: PickerViewDelegate
extension ScanAssetCheckListViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let view = view as? ScanAssetCheckList else { return }
        searchType = item[row]
        view.pickerView.value = item[row].name
    }
}

// MARK: PickerViewDataSource
extension ScanAssetCheckListViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return item.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return item[row].name
    }
}

extension ScanAssetCheckListViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        query = searchBar.text
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let value = searchBar.text else { return }

        SVProgressHUD.show()
        fetch(value: value).done { assets in
            SVProgressHUD.dismiss()
            AppDataManager.shared.set(key: DataKey.models.rawValue, value: assets)
            for item in assets.filter({ $0.validated }) {
                self.checkList[item.code!] = false
            }
            DispatchQueue.main.async {
                self.checkView?.isEmpty = self.models.isEmpty
                self.checkView?.tableView.reloadData()
            }
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }
    }
}
