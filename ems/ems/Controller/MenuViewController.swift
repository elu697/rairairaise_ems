//
//  MenuViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal protocol MenuDelegate: AnyObject {
    func modeChanged(type: MenuViewController.MenuType, viewController: UIViewController)
}

internal class MenuViewController: UIViewController {
    // MARK: - Property
    internal let menuView = MenuView()
    private var tableView: UITableView? {
        return (self.view as? MenuView)?.tableView
    }
    internal weak var delegate: MenuDelegate?

    internal enum MenuType: Int, CaseIterable {
        case change
        case check
        case register
        case qr

        internal var title: String {
            switch self {
            case .change:
                return "資産情報変更"
            case .check:
                return "資産情報確認"
            case .register:
                return "資産情報登録"
            case .qr:
                return "QRコード生成"
            }
        }
    }

    // MARK: - Default
    override internal func loadView() {
        self.view = self.menuView
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .white
        self.controllerSetting()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
        tableView?.dataSource = self
        tableView?.delegate = self
        // Do any additional setup after loading the view.
    }

    // MARK: - Layout
    private func controllerSetting() {
        self.setRightCloseBarButtonItem()
        self.setNavigationBarTitleString(title: R.string.localized.menuViewNavigationTitle())
    }
}

extension MenuViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuType.allCases.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = MenuType(rawValue: indexPath.row)?.title
        cell.textLabel?.textColor = .darkGray
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        cell.textLabel?.textAlignment = .center
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {
            dissmissView()
            return
        }
        dissmissView()
        delegate?.modeChanged(type: menuType, viewController: self)
    }
}
