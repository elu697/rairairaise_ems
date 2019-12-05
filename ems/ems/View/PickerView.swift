//
//  PickerView.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/04.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

internal class PickerView: UIView {
    private let picker: UIPickerView
    private let textField: UITextField

    internal var placeHolder: String {
        set {
            textField.placeholder = newValue
        }
        get {
            return textField.placeholder ?? ""
        }
    }

    internal var value: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }

    internal weak var delegate: UIPickerViewDelegate? {
        set {
            picker.delegate = newValue
        }
        get {
            return picker.delegate
        }
    }
    internal weak var dataSource: UIPickerViewDataSource? {
        set {
            picker.dataSource = newValue
        }
        get {
            return picker.dataSource
        }
    }

    override init(frame: CGRect) {
        picker = UIPickerView()
        textField = UITextField(frame: .zero)
        super.init(frame: .zero)

        textField.font = .boldSystemFont(ofSize: 14)

        picker.showsSelectionIndicator = true
        textField.inputView = picker
        textField.textAlignment = .center
        textField.allowsEditingTextAttributes = false
        textField.textColor = .gray

        textField.layer.addBorder(edge: .all, color: .gray, thickness: 0.5)
        addSubview(textField)
    }

    override func updateConstraints() {
        super.updateConstraints()

        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
