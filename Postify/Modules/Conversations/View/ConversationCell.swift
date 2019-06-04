//
//  ConversationCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Visually
import Reusable

class ConversationCell: UITableViewCell, Reusable {
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dummyTitleLabel = UILabel()
    private let lastMessageLabel = UILabel()
    private let dateLabel = UILabel()
    private let detailsButton = UIButton(type: .system)
    private let separator = Separator()
    private var onTap: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: ConversationViewModel, onTap: @escaping () -> ()) {
        self.onTap = onTap
        titleLabel.text = viewModel.title
        lastMessageLabel.text = viewModel.lastMessage
        dateLabel.text = viewModel.lastMessageDate
        if let url = viewModel.imageURL {
            itemImageView.setImage(with: url)
        } else {
            itemImageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
}

private extension ConversationCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        configureSubviews()
        configureTarget()
    }
    
    func addSubviews() {
        contentView.addSubviews(itemImageView,
                                titleLabel,
                                dummyTitleLabel,
                                lastMessageLabel,
                                dateLabel,
                                detailsButton,
                                separator)
    }
    
    func setupConstraints() {
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        lastMessageLabel.setContentCompressionResistancePriority(.defaultLow - 1, for: .vertical)
        var c: [NSLayoutConstraint] = []
        c += H(|-itemImageView[90]-8-titleLabel-8-|)
        c += H(itemImageView-8-lastMessageLabel->=8-|)
        c += H(itemImageView-8-dateLabel->=8-detailsButton-8-|)
        c += V(|-itemImageView-|)
        c += V(|-8-titleLabel-4-lastMessageLabel->=0-detailsButton-separator-|)
        c += [dateLabel.centerYAnchor.constraint(equalTo: detailsButton.centerYAnchor, constant: 0)]
        c += V(|-8-dummyTitleLabel)
        c += H(itemImageView-8-dummyTitleLabel)
        c += H(|-separator-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackSemibold18TextStyle().apply(to: titleLabel)
        Styles.blackSemibold18TextStyle().apply(to: dummyTitleLabel)
        Styles.blackRegular14LabelStyle().apply(to: lastMessageLabel)
        Styles.x64112BSemibold15TextStyle().apply(to: detailsButton)
        Styles.grayLight13TextStyle().apply(to: dateLabel)
    }
    
    func configureSubviews() {
        titleLabel.numberOfLines = 1
        lastMessageLabel.numberOfLines = 1
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.masksToBounds = true
        itemImageView.clipsToBounds = true
        clipsToBounds = true
        detailsButton.setTitle(LocalizedStrings.details, for: .normal)
        dateLabel.text = "27.10.2018"
        dummyTitleLabel.text = " "
    }
    
    func configureTarget() {
        detailsButton.addTarget(self,
                                action: #selector(didTapDetails),
                                for: .touchUpInside)
    }
    
    @objc func didTapDetails() {
        onTap?()
    }
}
