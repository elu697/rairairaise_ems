//
//  ScanView.swift
//  ems
//
//  Created by El You on 2019/06/29.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ScanView: UIView {
    //MARK: - Property //変数定義
    let scanPreviewView = QRCodeReaderView()
    let scanBtn = UIButton(type: .system)

    //MARK: - Default //init,viewdidload等標準関数
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(self.scanPreviewView)
        self.addSubview(self.scanBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.scanPreviewViewLayoutSetting()
        self.scanBtnLayoutSetting()
    }

    //MARK: - Layout //snpを使ったレイアウトの設定
    private func scanPreviewViewLayoutSetting() {
        self.scanPreviewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func scanBtnLayoutSetting() {
        self.scanBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-70)
            make.width.height.equalTo(70)
        }
        
        self.scanBtn.cornerRadius = 35
        self.scanBtn.borderWidth = 5
        self.scanBtn.borderColor = .gray
        self.scanBtn.setBackgroundColor(color: .clear, forState: .normal)
        self.scanBtn.setBackgroundColor(color: .white, forState: .highlighted)
    }


    //MARK: - Function  //通信処理や計算などの処理
    //MARK: - Action //addtargetの対象となるようなユーザーに近い処理

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
