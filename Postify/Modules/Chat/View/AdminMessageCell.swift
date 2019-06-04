//
//  AdminMessageCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 15/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

class AdminMessageCell: UITableViewCell, Reusable {
    private let messageLabel = UILabel()
    private lazy var cellHeightConstraint: NSLayoutConstraint =
        contentView.heightAnchor.constraint(equalToConstant: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: String, height: CGFloat) {
        messageLabel.text = viewModel
        cellHeightConstraint.constant = height
    }
}

private extension AdminMessageCell {
    func setup() {
        contentView.addSubview(messageLabel)
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-messageLabel-|)
        c += V(|-messageLabel-|)
        c += [cellHeightConstraint]
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.lightGrayRegular17TextStyle().apply(to: messageLabel)
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
    }
}
