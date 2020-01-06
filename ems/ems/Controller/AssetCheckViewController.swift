//
//  AssetCheckViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/11/28.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import PromiseKit
import SVProgressHUD
import UIKit

internal class AssetCheckViewController: UIViewController {
    override internal func loadView() {
        view = AssetCheckView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        setRightCloseBarButtonItem()
        setNavigationBarTitleString(title: "資産情報確認")

        view.setNeedsUpdateConstraints()
    }

    private func setInputValue(value: Asset) {
        guard let view = view as? AssetCheckView else { return }

        view.content.codeTxf.text = value.code
        view.content.nameTxf.text = value.name
        view.content.adminTxf.text = value.admin
        view.content.userTxf.text = value.user
        view.content.placeTxf.text = value.location
        view.content.numberTxf.text = String(value.quantity)
        view.content.lostSwitch.setSwitchState(state: value.loss ? .on : .off, animated: true, completion: nil)
        view.content.discardSwitch.setSwitchState(state: value.discard ? .on : .off, animated: true, completion: nil)
    }

    internal func fetch(value: String) -> Promise<Void> {
        print("fetch")
        return DBStore.shared.search(field: .code, value: value).then { models -> Promise<Void> in
            if let model = models.first {
                self.setInputValue(value: model)
                return Promise<Void>()
            } else {
                return Promise<Void>(error: DBStoreError.notFound)
            }
        }
    }
}
