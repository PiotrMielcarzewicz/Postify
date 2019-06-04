//
//  TitleCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import Reusable
import UIKit

class TitleCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private lazy var titleSubtitleVerticalConstraint = titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: TitleCellViewModel) {
        titleLabel.text = viewModel.title
        
        if let subtitle = viewModel.subtitle {
            titleSubtitleVerticalConstraint.constant = -16
            subtitleLabel.text = subtitle
        } else {
            titleSubtitleVerticalConstraint.constant = 0
            subtitleLabel.text = nil
        }
        
        switch viewModel.titleSize {
        case .big:
            Styles.whiteBold46TextStyle().apply(to: titleLabel)
        case .normal:
            Styles.whiteBold35TextStyle().apply(to: titleLabel)
        }
    }
}

private extension TitleCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                subtitleLabel)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-40-titleLabel)
        c += V(subtitleLabel-|)
        c += H(|-6-titleLabel-6-|)
        c += H(|-40-subtitleLabel-40-|)
        c += [titleSubtitleVerticalConstraint]
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.whiteBold46TextStyle().apply(to: titleLabel)
        Styles.whiteRegular23TextStyle().apply(to: subtitleLabel)
        subtitleLabel.numberOfLines = 0
        [titleLabel,
         subtitleLabel].forEach { $0.textAlignment = .center }
        backgroundColor = .clear
    }
}
