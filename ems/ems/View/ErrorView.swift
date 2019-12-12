//
//  ErrorView.swift
//  ems
//
//  Created by El You on 2019/12/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import UIKit

internal class ErrorView: UIView {
    internal let errorLbl: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .systemRed
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 20)
        return lbl
    }()

    internal var actionBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("閉じる", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.setTitle("閉じる", for: .highlighted)
        btn.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.contentEdgeInsets = .init(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        btn.sizeToFit()
        return btn
    }()

    override internal init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(errorLbl)
        self.addSubview(actionBtn)
        self.backgroundColor = .white
        actionBtn.isHidden = true
    }

    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
        errorLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(200)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(100)
        }

        actionBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-180)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
