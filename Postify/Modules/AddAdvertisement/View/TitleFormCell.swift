//
//  TitleFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol TitleFormProvider: class {
    func getEnteredTitle() -> String
}

class TitleFormCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let titleTextField = UITextField()
    private var enteredTitle: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: String?) {
        if enteredTitle == nil {
            enteredTitle = viewModel
            titleTextField.text = viewModel
        }
    }
}

extension TitleFormCell: TitleFormProvider {
    func getEnteredTitle() -> String {
        return titleTextField.text ?? ""
    }
}

private extension TitleFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setDefaultTexts()
        setDelegate()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                titleTextField)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-titleTextField-16-|)
        c += V(|-16-titleLabel-16-titleTextField-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: titleTextField)
    }
    
    func setDefaultTexts() {
        titleLabel.text = LocalizedStrings.title
        titleTextField.placeholder = LocalizedStrings.typeTitle
    }
    
    func setDelegate() {
        titleTextField.delegate = self
    }
}

extension TitleFormCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let range = Range(range, in: textField.text ?? "")!
        let newText = textField.text?.replacingCharacters(in: range, with: string)
        enteredTitle = newText
        return true
    }
}
