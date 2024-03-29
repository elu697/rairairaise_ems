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
    internal weak var delegate: ProfileDelegate?
    private static var nowPlace = ""

    // MARK: - Default

    override internal func loadView() {
        view = ProfileView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        controllerSetting()

        // Do any additional setup after loading the view.
    }
    // MARK: - Layout
    private func controllerSetting() {
        guard let view = view as? ProfileView else { return }
        view.inputField.backgroundColor = .white
        view.inputField.text = ProfileViewController.nowPlace
        view.reloadBtn.addTarget(self, action: #selector(relaod), for: .touchUpInside)
    }
    // MARK: - Function

    @objc
    private func relaod() {
        guard let view = view as? ProfileView else { return }
        print("tap")
        if let text = view.inputField.text {
            ProfileViewController.nowPlace = text
        }
        delegate?.reload(value: view.inputField.text)
    }
    // MARK: - Action
}

internal protocol ProfileDelegate: AnyObject {
    func reload(value: String?)
}
