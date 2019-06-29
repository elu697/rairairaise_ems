//
//  ScanViewController.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import QRCodeReader


class ScanViewController: UIViewController {
    //MARK: - Property //変数定義
    let scanView = ScanView()
    let scanReader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)

    //MARK: - Default //init,viewdidload等標準関数
    override func loadView() {
        super.loadView()
        //self.viewとself.scanViewは同じメモリアドレスだからself.scanViewがsuperView
        self.view = self.scanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanView.backgroundColor = .white
        self.scanSetting()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Layout //snpを使ったレイアウトの設定
    //MARK: - Function  //通信処理や計算などの処理
    
    func scanSetting() {
        let scanViewBuild = QRCodeReaderViewControllerBuilder { (build) in
            build.reader = self.scanReader
            build.showTorchButton = true
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.3)
            build.preferredStatusBarStyle = .lightContent
        }
        self.scanView.scanPreviewView.setupComponents(with: scanViewBuild)

        self.scanReader.stopScanningWhenCodeIsFound = false
        self.scanReader.startScanning()
    }
    //MARK: - Action //addtargetの対象となるようなユーザーに近い処理

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
