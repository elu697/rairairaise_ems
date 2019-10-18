//
//  ProfileViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit

internal class ProfileViewController: UIViewController {
    // MARK: - Property
    // MARK: - Default

    override internal func loadView() {
        view = ProfileView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        controllerSetting()

        // Do any additional setup after loading the view.
    }
    // MARK: - Layout
    private func controllerSetting() {
        guard let view = view as? ProfileView else { return }
        view.nowPlace.text = "現在地: "
        view.input.backgroundColor = .white
    }
    // MARK: - Function
    // MARK: - Action
}
