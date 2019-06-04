//
//  EmptyDataSetCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 09/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

class EmptyDataSetCell: UITableViewCell, Reusable {
    private let progressIndicator = UIActivityIndicatorView(style: .gray)
    private let emptyDataLabel = UILabel()
    private lazy var cellHeightConstraint: NSLayoutConstraint =
        contentView.heightAnchor.constraint(equalToConstant: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: EmptyDataSetViewModel, height: CGFloat) {
        cellHeightConstraint.constant = height
        switch viewModel {
        case let .text(text):
            progressIndicator.stopAnimating()
            emptyDataLabel.text = text
            progressIndicator.isHidden = true
            emptyDataLabel.isHidden = false
        case .loading:
            progressIndicator.startAnimating()
            emptyDataLabel.text = nil
            progressIndicator.isHidden = false
            emptyDataLabel.isHidden = true
        }
    }
}

private extension EmptyDataSetCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(progressIndicator,
                                emptyDataLabel)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += [cellHeightConstraint]
        c += V(|-progressIndicator-|)
        c += H(|-progressIndicator-|)
        c += V(|-emptyDataLabel-|)
        c += H(|-16-emptyDataLabel-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.grayLight15TextStyle().apply(to: emptyDataLabel)
        emptyDataLabel.textAlignment = .center
        emptyDataLabel.numberOfLines = 0
    }
}
