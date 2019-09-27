//
//  MenuViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal protocol MenuDelegate {
    func modeChanged(type: MenuViewController.MenuType)
}

internal class MenuViewController: UIViewController {
    // MARK: - Property
    internal let menuView = MenuView()
    private var tableView: UITableView? {
        return (self.view as? MenuView)?.tableView
    }
    internal var delegate: MenuDelegate?

    enum MenuType: Int, CaseIterable {
        case register // 登録
        case check

        internal var title: String {
            switch self {
            case .register:
                return "資産情報登録"
            case .check:
                return "資産情報確認"
            }
        }
    }

    // MARK: - Default
    override internal func loadView() {
        self.view = self.menuView
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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

    // MARK: - Function
    // MARK: - Action

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension MenuViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuType.allCases.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.textLabel?.text = MenuType(rawValue: indexPath.row)?.title
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = MenuType(rawValue: indexPath.row) else {
            dissmissView()
            return
        }
        delegate?.modeChanged(type: type)
        dissmissView()
    }
}
