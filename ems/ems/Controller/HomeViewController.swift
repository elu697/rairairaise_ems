//
//  HomeViewController.swift
//  ems
//
//  Created by El You on 2019/06/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import AVFoundation
import SVProgressHUD
import UIKit

internal class HomeViewController: UIViewController {
    // MARK: - Property
    // MARK: - Default
    //    override func loadView() {
    //        super.loadView() t
    ////        self.view = HomeView()
    //
    //    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.show()
        SVProgressHUD.dismiss()
        DBStore.share.update(code: "0000", set: { asset in
            asset.admin = "me"
            asset.user = "you"
            asset.name = "机"
            asset.location = "123"
            print("Assets: set")
        }, complete: { error in
            print("Assets completed: \(error?.localizedDescription ?? "sucess")")
        })
        self.present(ScanViewController(scanType: .home), animated: true, completion: nil)
    }

    // MARK: - Layout
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
