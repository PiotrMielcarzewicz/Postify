//
//  EditableAdvertisementCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually
import Reusable

class AdvertisementCell: UITableViewCell, Reusable {
    private let dateFormatter = AppDateFormatterImp()
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dummyTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let dateLabel = UILabel()
    private let separator = Separator()
    private let archivedOverlayView = ArchivedOverlayView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: Advertisement) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        itemImageView.setImage(with: viewModel.imageURLs.first!)
        dateLabel.text = dateFormatter.date(from: viewModel.timestamp, template: .dayMonthYear)
        if viewModel.price != 0 {
            priceLabel.text = "$\(viewModel.price)"
        } else {
            priceLabel.text = LocalizedStrings.free
        }
    }
}

private extension AdvertisementCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        configureSubviews()
    }
    
    func addSubviews() {
        contentView.addSubviews(itemImageView,
                                titleLabel,
                                dummyTitleLabel,
                                descriptionLabel,
                                priceLabel,
                                dateLabel,
                                separator,
                                archivedOverlayView)
    }
    
    func setupConstraints() {
        priceLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow - 1, for: .vertical)
        var c: [NSLayoutConstraint] = []
        c += H(|-itemImageView[120]-8-titleLabel->=8-priceLabel-8-|)
        c += H(itemImageView-8-descriptionLabel->=8-|)
        c += H(itemImageView->=8-dateLabel-8-|)
        c += V(|-itemImageView)
        c += [itemImageView.bottomAnchor.constraint(equalTo: separator.bottomAnchor)]
        c += V(|-8-titleLabel-2-descriptionLabel->=0-dateLabel-8-separator-|)
        c += [priceLabel.centerYAnchor.constraint(equalTo: dummyTitleLabel.centerYAnchor, constant: 0)]
        c += V(|-8-dummyTitleLabel)
        c += H(itemImageView-8-dummyTitleLabel)
        c += H(|-separator-|)
        c += [archivedOverlayView.bottomAnchor.constraint(equalTo: separator.bottomAnchor)]
        c += H(|-archivedOverlayView-|)
        c += V(|-archivedOverlayView)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold18TextStyle().apply(to: titleLabel)
        Styles.blackSemibold18TextStyle().apply(to: dummyTitleLabel)
        Styles.blackRegular14LabelStyle().apply(to: descriptionLabel)
        Styles.x64112BSemibold15TextStyle().apply(to: priceLabel)
        Styles.grayLight13TextStyle().apply(to: dateLabel)
    }
    
    func configureSubviews() {
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.masksToBounds = true
        itemImageView.clipsToBounds = true
        clipsToBounds = true
        dateLabel.text = "27.10.2018"
        dummyTitleLabel.text = " "
        archivedOverlayView.isHidden = true
    }
}


