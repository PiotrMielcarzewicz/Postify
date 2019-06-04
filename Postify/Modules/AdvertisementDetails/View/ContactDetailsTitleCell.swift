//
//  ContactDetailsTitleCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually
import Reusable

class ContactDetailsTitleCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: String) {
        titleLabel.text = viewModel
    }
}

private extension ContactDetailsTitleCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-16-|)
        c += V(|-16-titleLabel-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold18TextStyle().apply(to: titleLabel)
        titleLabel.numberOfLines = 0
    }
}
