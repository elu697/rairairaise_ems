//
//  infoView.swift
//  ems
//
//  Created by El You on 2019/07/06.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit

class infoView: UIView {
    // MARK: - Property
    let scanCountLbl = UILabel()
    let infoMsgLbl = UILabel()

    // MARK: - Default
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(self.scanCountLbl)
        self.addSubview(self.infoMsgLbl)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.scanCountLblLayoutSetting()
        self.infoMsgLblLayoutSetting()
    }

    // MARK: - Layout
    private func scanCountLblLayoutSetting() {

    }

    private func infoMsgLblLayoutSetting() {

    }
    // MARK: - Function
    // MARK: - Action

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
