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


class ScanViewController: UIViewController {
    //MARK: - Property //変数定義
    let scanView = ScanView()
    let scanReader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)

    private var scanCode: String = ""

    //MARK: - Default //init,viewdidload等標準関数
    override func loadView() {
        super.loadView()
        //self.viewとself.scanViewは同じメモリアドレスだからself.scanViewがsuperView
        self.view = self.scanView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanView.backgroundColor = .white
        self.scanerSetting()
        self.actionSetting()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scanReader.startScanning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanReader.stopScanning()
    }

    //MARK: - Layout //snpを使ったレイアウトの設定
    //MARK: - Function  //通信処理や計算などの処理
    private func scanerSetting() {
        let scanViewBuild = QRCodeReaderViewControllerBuilder { (build) in
            build.reader = self.scanReader
            build.showTorchButton = false
            build.showSwitchCameraButton = false
            build.showCancelButton = false
            build.showOverlayView = true
            build.handleOrientationChange = true
            build.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.3)
            build.preferredStatusBarStyle = .default
        }
        self.scanView.scanPreviewView.setupComponents(with: scanViewBuild)

        self.scanReader.didFindCode = { (result) in
            if result.value != self.scanCode {
                self.scanCode = result.value
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.scanView.scanPreviewView.overlayView?.setState(.normal)
                    self.scanCode.removeAll()
                }
                Sound.tone(mode: .success)
                self.scanView.scanPreviewView.overlayView?.setState(.valid)
                //TODO: TODO
                print(result)
            }
        }

        self.scanReader.didFailDecoding = { () in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.scanView.scanPreviewView.overlayView?.setState(.normal)
            }
            Sound.tone(mode: .fail)
            self.scanView.scanPreviewView.overlayView?.setState(.wrong)
        }
        self.scanReader.stopScanningWhenCodeIsFound = false
        self.scanReader.startScanning()
    }

    private func actionSetting() {
        self.scanView.scanBtn.addTarget(self, action: #selector(tappedScanBtn), for: .touchUpInside)
    }
    //MARK: - Action //addtargetの対象となるようなユーザーに近い処理
    @objc private func tappedScanBtn() {
        Sound.tone(mode: .success)
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
