//
//  MenuViewController.swift
//  ems
//
//  Created by El You on 2019/06/30.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import Material

class MenuViewController: UIViewController  {
    //MARK: - Property
    let menuView = MenuView()
    
    //MARK: - Default
    override func loadView() {
        super.loadView()
        self.view = self.menuView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.controllerSetting()
        
        // Do any additional setup after loading the view.
    }
    //MARK: - Layout
    private func controllerSetting() {
        self.setLeftBackBarButtonItem(image: Constants.image.back)
        self.setNavigationBarTitleString(title: R.string.localized.menuViewNavigationTitle())
    }
    //MARK: - Function
    //MARK: - Action

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
