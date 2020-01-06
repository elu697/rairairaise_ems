//
//  RegisterViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/18.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

internal class RegisterViewController: UIViewController {
    override internal func loadView() {
        view = RegisterView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setRightCloseBarButtonItem()
        setNavigationBarTitleString(title: "資産情報登録")

        guard let view = view as? RegisterView else { return }
        view.registBtn.addTarget(self, action: #selector(regist), for: .touchUpInside)
        view.driveBtn.addTarget(self, action: #selector(drive), for: .touchUpInside)

        view.setNeedsUpdateConstraints()
    }

    @objc
    internal func drive() {
        pushNewNavigationController(rootViewController: GoogleDriveFileListViewController(isRoot: true, isPDFSelect: false))
    }

    @objc
    internal func regist() {
        guard let viewController = children.first as? ScanInfoInputViewController else { return }
        guard let code = viewController.inputedValue["code"] as? String else {
            SVProgressHUD.showError(withStatus: "資産コードは必須入力です。")
            return
        }
        guard !code.isEmptyInWhiteSpace else {
            SVProgressHUD.showError(withStatus: "空白のみの入力は受け付けられません。")
            return
        }
        SVProgressHUD.show()
        DBStore.shared.regist(Asset(value: viewController.inputedValue)).done {
            SVProgressHUD.showSuccess(withStatus: "登録に成功しました")
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }
    }

    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let vc = ScanInfoInputViewController()
        vc.mode = .register
        updateInfoView(viewController: vc)
    }

    private func updateInfoView(viewController: UIViewController) {
        if !children.isEmpty {
            guard let child = children.first else { return }
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        guard let view = view as? RegisterView, view.content.bounds != .zero else { return }
        addChild(viewController)
        viewController.view.frame = view.content.bounds
        view.content.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
