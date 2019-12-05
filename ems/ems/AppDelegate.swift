//  AppDelegate.swift
//  ems
//
//  Created by El You on 2019/06/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

// MARK: コメント使い方
// MARK: - 区切り付きマークアップコメント
// MARK: マークアップコメント

// TODO: - 区切り付きマークアップTODO
// TODO: マークアップTODO

// FIXME: - 区切り付きマークアップ修正箇所
// FIXME: マークアップ修正箇所

// MARK: - Property //変数定義
// MARK: - Default //init,viewdidload等標準関数
// MARK: - Layout //snpを使ったレイアウトの設定
// MARK: - Function  //通信処理や計算などの処理
// MARK: - Action //addtargetの対象となるようなユーザーに近い処理

import SnapKit
import SVProgressHUD
import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        sleep(1) //スプラッシュ画面をわざとみせるだけ
        self.initializedApplication()

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func initializedApplication() {
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        let rootVC = HomeViewController()
        rootVC.modalPresentationStyle = .fullScreen

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
}
