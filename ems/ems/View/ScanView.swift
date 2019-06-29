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
    var scanPreviewView = QRCodeReaderView()

    //MARK: - Default //init,viewdidload等標準関数
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(self.scanPreviewView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.scanPreviewViewLayoutSetting()

    }

    //MARK: - Layout //snpを使ったレイアウトの設定
    private func scanPreviewViewLayoutSetting() {
        self.scanPreviewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
//            make.edges.top.left.right.equalToSuperview()
//            make.height.equalTo(self.snp.width)
        }
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
