//
//  HomeViewController.swift
//  ems
//
//  Created by El You on 2019/06/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    //MARK: - Property
    //MARK: - Default
    //MARK: - Layout
    //MARK: - Function
    //MARK: - Action
    
//    override func loadView() {
//        super.loadView()
////        self.view = HomeView()
//
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(ScanViewController(), animated: true, completion: nil)
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
