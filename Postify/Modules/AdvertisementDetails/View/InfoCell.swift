//
//  InfoCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import Reusable
import UIKit

class InfoCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: InfoViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

private extension InfoCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                valueLabel)
    }
    
    func setupConstraints() {
        valueLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-8-valueLabel-16-|)
        c += V(|-16-titleLabel-|)
        c += V(|-16-valueLabel-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.lightGrayRegular17TextStyle().apply(to: titleLabel)
        Styles.blackRegular17TextStyle().apply(to: valueLabel)
    }
}
