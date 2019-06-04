//
//  CategoryCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

class CategoryCell: UITableViewCell, Reusable {
    private let nameLabel = UILabel()
    private let arrowIcon = UIImageView()
    private let separator = Separator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: CategoryViewModel) {
        nameLabel.text = viewModel.name
        switch viewModel.type {
        case .leaf:
            arrowIcon.isHidden = true
        case .node:
            arrowIcon.isHidden = false
        }
    }
}

private extension CategoryCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        setIcon()
        applyStyling()
    }
    
    func addSubviews() {
        contentView.addSubviews(nameLabel,
                                arrowIcon,
                                separator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-nameLabel-16-arrowIcon[8]-16-|)
        c += V(arrowIcon[13])
        c += V(|-nameLabel-separator-|)
        c += H(|-separator-|)
        c += [arrowIcon.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    func setIcon() {
        arrowIcon.image = #imageLiteral(resourceName: "ic_arrow")
    }
    
    func applyStyling() {
        Styles.blackRegular17TextStyle().apply(to: nameLabel)
    }
}
