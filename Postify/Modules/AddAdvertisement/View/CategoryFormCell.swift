//
//  CategoryFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 07/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

protocol CategoryFormProvider: class {
    func getEnteredCategoryViewModel() -> CategoryViewModel?
}

class CategoryFormCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let categoryTextField = UITextField()
    private let selectButton = UIButton(type: .system)
    private var onSelect: (() -> ())?
    private var selectedViewModel: CategoryViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: CategoryViewModel? = nil, onSelect: (() ->())? = nil) {
        self.onSelect = onSelect
        if selectedViewModel == nil {
            self.selectedViewModel = viewModel
            categoryTextField.text = viewModel?.name
        }
    }
    
    func didSelect(_ viewModel: CategoryViewModel) {
        self.selectedViewModel = viewModel
        categoryTextField.text = viewModel.name
    }
}

extension CategoryFormCell: CategoryFormProvider {
    func getEnteredCategoryViewModel() -> CategoryViewModel? {
        return selectedViewModel
    }
}

private extension CategoryFormCell {
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
                                categoryTextField,
                                selectButton)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += H(|-16-categoryTextField-16-selectButton-16-|)
        c += V(titleLabel-16-selectButton)
        c += V(|-16-titleLabel-16-categoryTextField-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17BorderTextFieldStyle().apply(to: categoryTextField)
        Styles.x64112BSemibold17TextStyle().apply(to: selectButton)
    }
    
    func setDefaultTexts() {
        titleLabel.text = LocalizedStrings.category
        categoryTextField.placeholder = LocalizedStrings.notSelected
        selectButton.setTitle(LocalizedStrings.select, for: .normal)
    }
    
    func configureSubviews() {
        selectButton.addTarget(self, action: #selector(didTapSelect), for: .touchUpInside)
        categoryTextField.isUserInteractionEnabled = false
    }
    
    @objc func didTapSelect() {
        onSelect?()
    }
}
