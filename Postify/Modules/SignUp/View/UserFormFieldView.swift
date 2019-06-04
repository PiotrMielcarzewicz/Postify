//
//  UserFormFieldView.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually

class UserFormFieldView: UIView {
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let separator = Separator()
    
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
        }
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
}

private extension UserFormFieldView {
    func setup() {
        addSubviews()
        prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
    }
    
    func addSubviews() {
        addSubviews(titleLabel,
                    textField,
                    separator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-textField-16-|)
        c += H(|-16-separator-16-|)
        c += V(|-32-titleLabel-textField[40]-separator[1]-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.whiteBold19TextStyle().apply(to: titleLabel)
        Styles.whiteRegular17BorderTextFieldStyle().apply(to: textField)
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        backgroundColor = .clear
    }
}


//class UserFormFieldView: UIView {
//    private let titleLabel = UILabel()
//    private let textField = UITextField()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func hydrate(with viewModel: FormFieldViewModel) {
//        titleLabel.text = viewModel.title
//        textField.text = viewModel.text
//        textField.placeholder = viewModel.placeholder
//        switch viewModel.type {
//        case .default:
//            textField.keyboardType = .default
//        case .numberPad:
//            textField.keyboardType = .numberPad
//        }
//    }
//
//    func getText() -> String {
//        return textField.text ?? ""
//    }
//}
//
//private extension UserFormFieldView {
//    func setup() {
//        addSubviews()
//        prepareSubviewsForAutolayout()
//        setupConstraints()
//        applyStyling()
//    }
//
//    func addSubviews() {
//        addSubviews(titleLabel,
//                    textField)
//    }
//
//    func setupConstraints() {
//        var c: [NSLayoutConstraint] = []
//        c += H(|-16-titleLabel-16-|)
//        c += H(|-16-textField-16-|)
//        c += V(|-32-titleLabel-16-textField-|)
//        NSLayoutConstraint.activate(c)
//    }
//
//    func applyStyling() {
//        Styles.whiteSemibold17TextStyle().apply(to: titleLabel)
//        Styles.whiteRegular17BorderTextFieldStyle().apply(to: textField)
//        backgroundColor = .clear
//    }
//}
