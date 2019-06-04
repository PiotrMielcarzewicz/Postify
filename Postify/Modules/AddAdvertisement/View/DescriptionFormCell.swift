//
//  DescriptionFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol DescriptionFormProvider: class {
    func getEnteredDescription() -> String
}

class DescriptionFormCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let descritpionTextView = UITextView()
    private var enteredDescription: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: String?) {
        if enteredDescription == nil {
            enteredDescription = viewModel
            descritpionTextView.text = viewModel
        }
    }
}

extension DescriptionFormCell: DescriptionFormProvider {
    func getEnteredDescription() -> String {
        return descritpionTextView.text
    }
}

private extension DescriptionFormCell {
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
                                descritpionTextView)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-descritpionTextView-16-|)
        c += V(|-16-titleLabel-16-descritpionTextView[200]-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17RoundBorderTextViewStyle().apply(to: descritpionTextView)
    }
    
    func setDefaultTexts() {
        titleLabel.text = LocalizedStrings.description
    }
    
    func setDelegate() {
        descritpionTextView.delegate = self
    }
}

extension DescriptionFormCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let range = Range(range, in: textView.text ?? "")!
        let newText = textView.text.replacingCharacters(in: range, with: text)
        enteredDescription = newText
        return true
    }
}
