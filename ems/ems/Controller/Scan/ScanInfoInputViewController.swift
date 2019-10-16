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
        view = ScanInfoInputView(isCodeEnable: false)
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.setNeedsUpdateConstraints()
    }
}
