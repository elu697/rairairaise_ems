//
//  AssetCheckViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/11/28.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

class AssetCheckViewController: UIViewController {
    override func loadView() {
        view = AssetCheckView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setRightCloseBarButtonItem()
        setNavigationBarTitleString(title: "資産情報確認")

        view.setNeedsUpdateConstraints()
    }

    private func setInputValue(value: Assets) {
        guard let view = view as? AssetCheckView else { return }

        view.content.codeTxf.text = value.code
        view.content.nameTxf.text = value.name
        view.content.adminTxf.text = value.admin
        view.content.userTxf.text = value.user
        view.content.placeTxf.text = value.location
        view.content.lostSwitch.setSwitchState(state: value.loss ? .on : .off, animated: true, completion: nil)
        view.content.discardSwitch.setSwitchState(state: value.discard ? .on : .off, animated: true, completion: nil)
    }

    internal func fetch(value: String, _ comp: @escaping (DBStore.DBStoreError?) -> Void) {
        SVProgressHUD.show()
        print("fetch")
        DBStore.share.search(field: .code, value: value, limit: 1) { assets, error in
            DispatchQueue.main.async {
                if let asset = assets?.first {
                    self.setInputValue(value: asset)
                } else {
                    comp(error != nil ? .failed : .notFound)
                    SVProgressHUD.dismiss()
                    return
                }

                comp(nil)
                SVProgressHUD.dismiss()
            }
        }
    }
}
