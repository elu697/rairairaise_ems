//
//  ScanInfoViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/13.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

internal class ScanInfoInputViewController: UIViewController {
    override internal func loadView() {
        view = ScanInfoInputView(isCodeEnable: true)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsUpdateConstraints()
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

        return value
    }

    private func validate() -> Bool {
        guard let view = view as? ScanInfoInputView, let code = view.codeTxf.text else { return false }
        return !code.isEmpty
    }
}
