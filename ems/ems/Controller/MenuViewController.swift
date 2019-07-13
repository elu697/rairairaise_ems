//
//  MenuViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Material
import UIKit

internal class MenuViewController: UIViewController {
    // MARK: - Property
    internal let menuView = MenuView()

    // MARK: - Default
    override internal func loadView() {
        self.view = self.menuView
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.controllerSetting()

        // Do any additional setup after loading the view.
    }

    // MARK: - Layout
    private func controllerSetting() {
        self.setLeftBackBarButtonItem(image: Constants.Image.back)
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
