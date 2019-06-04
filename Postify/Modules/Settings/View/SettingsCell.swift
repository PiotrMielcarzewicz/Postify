//
//  SettingsCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import UIKit
import Visually

class SettingsCell: UITableViewCell, Reusable {
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with option: SettingsOption) {
        titleLabel.text = option.title
        icon.image = option.icon
    }
}

private extension SettingsCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        addConstraints()
        applyStyling()
    }
    
    func addSubviews() {
        contentView.addSubviews(icon,
                                titleLabel)
    }
    
    func addConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-titleLabel-|)
        c += [icon.heightAnchor.constraint(equalToConstant: 28)]
        c += [icon.widthAnchor.constraint(equalToConstant: 28)]
        c += [icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)]
        c += H(|-16-icon-16-titleLabel-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackRegular17TextStyle().apply(to: titleLabel)
        icon.contentMode = .center
    }
}
