//
//  SeparatorCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually
import Reusable

class SeparatorCell: UITableViewCell, Reusable {
    private let separator = Separator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SeparatorCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(separator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-separator-|)
        c += V(|-16-separator-|)
        NSLayoutConstraint.activate(c)
    }
}
