//
//  EmptyCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

class EmptyCell: UITableViewCell, Reusable {
    private let emptyView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyCell {
    func setup() {
        contentView.addSubview(emptyView)
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        selectionStyle = .none
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-emptyView-|)
        c += V(|-emptyView[0]-|)
        NSLayoutConstraint.activate(c)
    }
}
