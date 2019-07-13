//
//  UIViewControllerEx.swift
//  FiMap
//
//  Created by AmamiYou on 2018/10/09.
//  Copyright © 2018 ammYou. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// Push ViewController on new NavigationController

    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setLeftBackBarButtonItem(action: Selector = #selector(tappedBackButton), image: UIImage? = Constants.image.back) {
        let barButtonItem = UIBarButtonItem()
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 30.0)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        barButtonItem.customView = button
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.navigationItem.leftBarButtonItem = barButtonItem
    }

    /// Sets the navigation bar menu on the left bar button.
    /// Also add the left gesture.
    func setRightCloseBarButtonItem(action: Selector = #selector(tappedCloseButton), image: UIImage? = Constants.image.back) {
        let barButtonItem = UIBarButtonItem()
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 30.0)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: action, for: .touchUpInside)
        barButtonItem.customView = button
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItem
    }

    @objc private func tappedBackButton() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func tappedCloseButton() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func setNavigationBarTitleString(title: String) {
        let titleLbl = UILabel()
        titleLbl.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.text = title
        titleLbl.sizeToFit()
        titleLbl.textColor = UIColor.black//Constants.Color.AppleGray
        titleLbl.textAlignment = .center
        titleLbl.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleLbl
    }

    func hideNavigationWhenSwipeView() {
        let _: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dissmissView))

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dissmissView))
        swipe.direction = .down
        swipe.cancelsTouchesInView = false
        view.addGestureRecognizer(swipe)
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        pan.cancelsTouchesInView = false
        view.addGestureRecognizer(pan)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func dissmissView() {
        self.dismiss(animated: true, completion: nil)
    }

    func pushNewNavigationController(rootViewController: UIViewController) {
        self.present(UINavigationController(rootViewController: rootViewController), animated: true, completion: nil)
    }

    //    func setNavigationBarTitleLogo() {
    //        let logoView = UIImageView(image: UIImage(named: "logo_pay_header"))
    //        logoView.contentMode = .scaleAspectFit
    //        self.navigationItem.titleView = logoView
    //    }
}
