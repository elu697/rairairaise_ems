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

        view.setNeedsUpdateConstraints()
    }

    @objc
    internal func regist() {
        guard let viewController = children.first as? ScanInfoInputViewController else { return }
        guard let value = viewController.getInputValue(), let code = value[.code] as? String else {
            showAlert(title: "エラー", message: "資産コードは必須入力です。", { _ in
                print("OK")
            }
            )
            return
        }
        guard !code.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "エラー", message: "空白のみの入力は受け付けられません。", { _ in
                print("OK")
            }
            )
            return
        }
        SVProgressHUD.show()
        DBStore.share.set({ asset in
            asset.code = code
            asset.name = value[.name] as? String
            asset.admin = value[.admin] as? String
            asset.user = value[.user] as? String
            asset.location = value[.location] as? String
            asset.loss = value[.loss] as? Bool ?? false
            asset.discard = value[.discard] as? Bool ?? false
            asset.quantity = Int(value[.quantity] as? String ?? "0") ?? 0
        }, { error in
            SVProgressHUD.dismiss()
            guard let error = error else {
                self.showAlert(title: "完了", message: "登録に成功しました。", { _ in
                    print("OK")
                }
                )
                return
            }
            self.showAlert(title: "エラー", message: error.descript, { _ in
                print("OK")
            }
            )
        }
        )
    }

    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let vc = ScanInfoInputViewController()
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
