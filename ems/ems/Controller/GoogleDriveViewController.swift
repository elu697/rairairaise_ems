//
//  GoogleDriveViewController.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/07.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class GoogleDriveViewController: UIViewController {
    override func loadView() {
        view = GoogleDriveView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setRightCloseBarButtonItem()
        setNavigationBarTitleString(title: "GoogleDrive")

        guard let view = view as? GoogleDriveView else { return }
        view.listBtn.addTarget(self, action: #selector(tappedListBtn), for: .touchUpInside)

        setupGIDSignIn()
    }

    private func setupGIDSignIn() {
        GIDSignIn.sharedInstance()?.scopes = [kGTLRAuthScopeDrive]
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    @objc private func tappedListBtn() {
        GoogleDriveWrapper.shared.listFilesInFolder("学校") { files, error in
            guard let fileList = files else {
                print("Error listing files: \(String(describing: error?.localizedDescription))")
                return
            }
            print(fileList.files?.description ?? "not found")
        }
    }
}
