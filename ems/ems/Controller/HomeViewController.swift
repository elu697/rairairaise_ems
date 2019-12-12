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
    private let errorVC = ErrorViewController()
    private let scanVC = ScanViewController()

    // MARK: - Property
    // MARK: - Default
    //    override func loadView() {
    //        super.loadView() t
    ////        self.view = HomeView()
    //
    //    }

    deinit {
        removeReachabilityObserver()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
    }

    override internal func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanVC.modalPresentationStyle = .fullScreen
        self.present(scanVC, animated: true, completion: nil)
        addReachabilityObserver()
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

extension HomeViewController: ReachabilityObserverDelegate {
    internal func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            print("internet connection")
            errorVC.dissmissView()
        } else {
            print("No internet connection")
            errorVC.modalPresentationStyle = .fullScreen
//            errorVC.is
            errorVC.setError(msg: "- オフライン -\n\nインターネット接続がないと\nこのシステムは利用できません")
            guard let vc = UIApplication.topViewController else { return }
            vc.present(errorVC, animated: true, completion: nil)
        }
    }
}
