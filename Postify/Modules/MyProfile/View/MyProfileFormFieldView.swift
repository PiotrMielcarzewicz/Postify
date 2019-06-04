//
//  MyProfileFormFieldView.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit

class MyProfileFormFieldView: UIView {
    private let titleLabel = UILabel()
    private let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: FormFieldViewModel) {
        titleLabel.text = viewModel.title + ":"
        textField.text = viewModel.text
        textField.attributedPlaceholder = NSAttributedString(string: viewModel.placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        switch viewModel.type {
        case .default:
            textField.keyboardType = .default
        case .numberPad:
            textField.keyboardType = .numberPad
        case .secure:
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
        case .locked:
            textField.isEnabled = false
            textField.style_setTextColor(.gray)
        }
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
}


private extension MyProfileFormFieldView {
    func setup() {
        addSubviews()
        prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
    }
    
    func addSubviews() {
        addSubviews(titleLabel,
                    textField)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-textField-16-|)
        c += V(|-16-titleLabel-16-textField-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: textField)
    }
}
