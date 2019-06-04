//
//  AdvertisementDescriptionCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually
import Reusable

class AdvertisementDescriptionCell: UITableViewCell, Reusable {
    private let descriptionLabel = UILabel()
    private let separator = Separator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: String) {
        descriptionLabel.text = viewModel
    }
}

private extension AdvertisementDescriptionCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(descriptionLabel,
                                separator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-16-descriptionLabel-16-|)
        c += H(|-separator-|)
        c += V(|-24-descriptionLabel-16-separator-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackRegular14LabelStyle().apply(to: descriptionLabel)
        descriptionLabel.numberOfLines = 0
    }
}
