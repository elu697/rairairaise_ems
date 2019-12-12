//
//  ErrorViewController.swift
//  ems
//
//  Created by El You on 2019/12/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit

internal class ErrorViewController: UIViewController {
    override internal func loadView() {
        self.view = ErrorView()
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        guard let view = view as? ErrorView else { return }
        view.actionBtn.addTarget(self, action: #selector(action), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    internal func setError(msg: String) {
        guard let view = view as? ErrorView else { return }
        view.errorLbl.text = msg
    }

    @objc
    internal func action() {
        self.dissmissView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
