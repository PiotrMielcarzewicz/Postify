//
//  OrLabelView.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

class OrLabelView: UIView {
    private let orLabel = UILabel()
    private let leftSeparator = Separator()
    private let rightSeparator = Separator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OrLabelView {
    func setup() {
        addSubviews()
        prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setText()
    }
    
    func addSubviews() {
        addSubviews(orLabel,
                    leftSeparator,
                    rightSeparator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-leftSeparator-8-orLabel-8-rightSeparator-|)
        c += V(|-orLabel-|)
        c += [leftSeparator.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
              rightSeparator.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
              leftSeparator.widthAnchor.constraint(equalTo: rightSeparator.widthAnchor, multiplier: 1.0)]
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.whiteRegular17TextStyle().apply(to: orLabel)
        [leftSeparator,
         rightSeparator].forEach { $0.color = .white }
    }
    
    func setText() {
        orLabel.text = LocalizedStrings.orCapitalized
    }
}
