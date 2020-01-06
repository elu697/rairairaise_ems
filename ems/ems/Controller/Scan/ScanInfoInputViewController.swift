//
//  ScanInfoViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import PromiseKit
import SVProgressHUD
import UIKit

internal class ScanInfoInputViewController: UIViewController {
    private var isFetching = false
    private var beforeCode = ""

    internal var mode: MenuViewController.MenuType = .change
    private var infoInputView: ScanInfoInputView? {
        return view as? ScanInfoInputView
    }

    private static var cash: Asset?

    override internal func loadView() {
        view = ScanInfoInputView(isCodeEnable: true)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsUpdateConstraints()

        if let cash = ScanInfoInputViewController.cash, mode == .change {
            setAssetValue(value: cash)
        }

        infoInputView?.codeTxf.delegate = self
        infoInputView?.nameTxf.delegate = self
        infoInputView?.adminTxf.delegate = self
        infoInputView?.userTxf.delegate = self
        infoInputView?.placeTxf.delegate = self
        infoInputView?.numberTxf.delegate = self
    }
}

// MARK: ValueIO
extension ScanInfoInputViewController {
    var inputedValue: [String: Any] {
        var value: [String: Any] = [:]
        value["code"] = infoInputView?.codeTxf.emptyText
        value["name"] = infoInputView?.nameTxf.emptyText
        value["admin"] = infoInputView?.adminTxf.emptyText
        value["user"] = infoInputView?.userTxf.emptyText
        value["location"] = infoInputView?.placeTxf.emptyText
        value["loss"] = infoInputView?.lostSwitch.isOn
        value["discard"] = infoInputView?.discardSwitch.isOn
        value["quantity"] = infoInputView?.numberTxf.emptyText

        return value
    }

    private func setAssetValue(value: Asset) {
        infoInputView?.codeTxf.text = value.code
        infoInputView?.nameTxf.text = value.name
        infoInputView?.adminTxf.text = value.admin
        infoInputView?.userTxf.text = value.user
        infoInputView?.placeTxf.text = value.location
        infoInputView?.numberTxf.text = String(value.quantity)
        infoInputView?.lostSwitch.setSwitchState(state: value.loss ? .on : .off, animated: true, completion: nil)
        infoInputView?.discardSwitch.setSwitchState(state: value.discard ? .on : .off, animated: true, completion: nil)

        ScanInfoInputViewController.cash = value
    }
}

// MARK: Network
extension ScanInfoInputViewController {
    func update() {
        SVProgressHUD.show()
        DBStore.shared.update(Asset(value: inputedValue)).done {
            SVProgressHUD.showSuccess(withStatus: "更新しました")
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }
    }

    func fetch(value: String) {
        guard !isFetching, value != beforeCode else {
            return
        }
        SVProgressHUD.show()
        isFetching = true
        print("fetch")

        DBStore.shared.search(field: .code, value: value).then { models -> Promise<Void> in
            if let model = models.first, let code = model.code {
                self.beforeCode = code
                self.setAssetValue(value: model)
                return Promise<Void>()
            } else {
                return Promise<Void>(error: DBStoreError.notFound)
            }
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }.finally {
            SVProgressHUD.dismiss()
        }
    }
}

extension ScanInfoInputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
