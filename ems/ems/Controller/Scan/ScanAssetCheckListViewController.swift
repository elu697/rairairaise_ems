//
//  ScanInfoListViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

internal class ScanAssetCheckListViewController: UIViewController {
    private var assets: [Assets] = []

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
}

extension ScanAssetCheckListViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        return cell
    }
}

extension ScanAssetCheckListViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className): tap")
    }
}
