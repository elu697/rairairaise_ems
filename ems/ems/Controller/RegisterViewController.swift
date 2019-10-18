//
//  RegisterViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/10/18.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit

internal class RegisterViewController: UIViewController {
    override internal func loadView() {
        view = RegisterView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        guard let view = view as? RegisterView else { return }
        view.registBtn.addTarget(self, action: #selector(regist), for: .touchUpInside)
    }

    @objc
    internal func regist() {
        print("登録")
        guard let viewController = children.first as? ScanInfoInputViewController else { return }
        guard let value = viewController.getInputValue(), let code = value[.code] as? String else { return }

        DBStore.share.set({ asset in
            asset.code = code
            asset.name = value[.name] as? String
            asset.admin = value[.admin] as? String
            asset.user = value[.user] as? String
            asset.location = value[.location] as? String
            asset.loss = value[.loss] as? Bool ?? false
            asset.discard = value[.discard] as? Bool ?? false
        }, { error in
            self.dissmissView()
            print(error?.localizedDescription ?? "")
        })
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
