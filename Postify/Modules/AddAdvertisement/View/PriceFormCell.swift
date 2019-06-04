//
//  PriceFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol PriceFormProvider: class {
    func getEnteredPrice() -> Float
}

class PriceFormCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let priceTextField = UITextField()
    private var enteredPriceString: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: Float?) {
        if enteredPriceString == nil, let viewModel = viewModel {
            priceTextField.text = "\(viewModel)"
        }
    }
}

extension PriceFormCell: PriceFormProvider {
    func getEnteredPrice() -> Float {
        guard let priceText = priceTextField.text?.replacingOccurrences(of: ",", with: "."),
              let price = Float(priceText) else { return 0 }
        return price
    }
}

private extension PriceFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setDefaultTexts()
        configureSubviews()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                priceTextField)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-priceTextField-16-|)
        c += V(|-16-titleLabel-16-priceTextField-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: priceTextField)
    }
    
    func setDefaultTexts() {
        titleLabel.text = LocalizedStrings.price
        priceTextField.placeholder = "0,0"
    }
    
    func configureSubviews() {
        priceTextField.keyboardType = .decimalPad
        priceTextField.delegate = self
    }
}

extension PriceFormCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var didChangeText = false
        defer {
            if didChangeText {
                let text = textField.text ?? ""
                guard let range = Range(range, in: text) else { fatalError() }
                let replacementText = text.replacingCharacters(in: range, with: string)
                enteredPriceString = replacementText
            }
        }
        
        guard let text = textField.text else {
            didChangeText = true
            return true
        }
        
        let splitTexts = text.split(separator: ",")
        guard splitTexts.count > 1 else {
            didChangeText = true
            return true
        }
        
        guard let range = Range(range, in: text) else {
            didChangeText = true
            return true
        }
        
        let replacementText = text.replacingCharacters(in: range, with: string)
        if splitTexts[1].count > 1 {
            if replacementText.count < text.count {
                didChangeText = true
            }
            return replacementText.count < text.count
        } else {
            didChangeText = true
            return true
        }
    }
}
