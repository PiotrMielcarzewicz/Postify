//
//  InsettedTableViewCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

class InsettedTableViewCell: UITableViewCell {
    var viewToPinToInsets: UIView {
        fatalError("This var is supposed to be overriden")
    }
    
    private lazy var leadingMarginConstraint: NSLayoutConstraint = {
        return viewToPinToInsets.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    }()
    private lazy var trailingMarginConstraint: NSLayoutConstraint = {
        return contentView.trailingAnchor.constraint(equalTo: viewToPinToInsets.trailingAnchor)
    }()
    private lazy var topMarginConstraint: NSLayoutConstraint = {
        return viewToPinToInsets.topAnchor.constraint(equalTo: contentView.topAnchor)
    }()
    private lazy var bottomMarginConstraint: NSLayoutConstraint = {
        return contentView.bottomAnchor.constraint(equalTo: viewToPinToInsets.bottomAnchor)
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInsets(_ insets: UIEdgeInsets) {
        leadingMarginConstraint.constant = insets.left
        trailingMarginConstraint.constant = insets.right
        topMarginConstraint.constant = insets.top
        bottomMarginConstraint.constant = insets.bottom
    }
}

private extension InsettedTableViewCell {
    func setup() {
        contentView.addSubview(viewToPinToInsets)
        contentView.prepareSubviewsForAutolayout()
        let constraints = [leadingMarginConstraint, trailingMarginConstraint, topMarginConstraint, bottomMarginConstraint]
        NSLayoutConstraint.activate(constraints)
    }
}
