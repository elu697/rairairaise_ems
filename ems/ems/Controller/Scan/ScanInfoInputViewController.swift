//
//  ScanInfoViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

internal class ScanInfoInputViewController: UIViewController {
    private var isFetching = false
    private var beforeCode = ""

    override internal func loadView() {
        view = ScanInfoInputView(isCodeEnable: true)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsUpdateConstraints()
    }

    private func setInputValue(value: Assets) {
        guard let view = view as? ScanInfoInputView else { return }

        view.codeTxf.text = value.code
        view.nameTxf.text = value.name
        view.adminTxf.text = value.admin
        view.userTxf.text = value.user
        view.placeTxf.text = value.location
        view.numberTxf.text = String(value.quantity)
        view.lostSwitch.setSwitchState(state: value.loss ? .on : .off, animated: true, completion: nil)
        view.discardSwitch.setSwitchState(state: value.discard ? .on : .off, animated: true, completion: nil)
    }

    internal func getInputValue() -> [Assets.Field: Any?]? {
        var value: [Assets.Field: Any?] = [:]

        guard validate() else { return nil }
        guard let view = view as? ScanInfoInputView else { return nil }

        value[.code] = view.codeTxf.text
        value[.name] = view.nameTxf.text
        value[.admin] = view.adminTxf.text
        value[.user] = view.userTxf.text
        value[.location] = view.placeTxf.text
        value[.loss] = view.lostSwitch.isOn
        value[.discard] = view.discardSwitch.isOn
        value[.quantity] = view.numberTxf.text

        return value
    }

    private func validate() -> Bool {
        guard let view = view as? ScanInfoInputView, let code = view.codeTxf.text else { return false }
        return !code.isEmpty
    }

    internal func fetch(value: String, _ comp: @escaping (DBStore.DBStoreError?) -> Void) {
        guard !isFetching, value != beforeCode else { return }
        SVProgressHUD.show()
        isFetching = true
        print("fetch")
        DBStore.share.search(field: .code, value: value, limit: 1) { assets, error in
            DispatchQueue.main.async {
                if let asset = assets?.first {
                    self.beforeCode = asset.code
                    self.setInputValue(value: asset)
                } else {
                    comp(error != nil ? .failed : .notFound)
                    SVProgressHUD.dismiss()
                    self.isFetching = false
                    return
                }

                comp(nil)
                SVProgressHUD.dismiss()
                self.isFetching = false
            }
        }
    }
}
