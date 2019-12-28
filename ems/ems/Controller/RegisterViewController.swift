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
        guard let value = viewController.getInputValue(), let code = value[.code] as? String else {
            SVProgressHUD.showError(withStatus: "資産コードは必須入力です。")
            return
        }
        guard !code.trimmingCharacters(in: .whitespaces).isEmpty else {
            SVProgressHUD.showError(withStatus: "空白のみの入力は受け付けられません。")
            return
        }
        SVProgressHUD.show()
        /*DBStore.shared.regist({ model in
            model.code = code
            model.name = value[.name] as? String
            model.admin = value[.admin] as? String
            model.user = value[.user] as? String
            model.location = value[.location] as? String
            model.loss = value[.loss] as? Bool ?? false
            model.discard = value[.discard] as? Bool ?? false
            model.quantity = Int(value[.quantity] as? String ?? "0") ?? 0
        }).done {
            SVProgressHUD.showSuccess(withStatus: "登録に成功しました")
        }.catch { error in
            SVProgressHUD.showError(withStatus: (error as? DBStoreError)?.descript)
        }*/
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
