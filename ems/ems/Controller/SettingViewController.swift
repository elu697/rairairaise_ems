//
//  SettingViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Eureka
import UIKit

internal class SettingViewController: FormViewController {
    // MARK: - Property
    // MARK: - Default
    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.controllerSetting()
        // Do any additional setup after loading the view.
    }

    // MARK: - Layout
    private func controllerSetting() {
        self.setRightCloseBarButtonItem()
        self.setNavigationBarTitleString(title: R.string.localized.settingViewNavigationTitle())

        self.form +++ Section("設定項目")
        <<< SwitchRow("sound") { row in
            row.title = "スキャン完了音"
            row.value = true
        }.onChange { row in
            UDManager.setUD(key: .sound, value: row.value as Any)
        }.cellSetup({ _, row in
                row.value = UDManager.getUD(key: .sound) as? Bool ?? true
            }
        )
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
