//
//  ArchivedOverlayView.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 13/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit

class ArchivedOverlayView: UIView {
    private let archivedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ArchivedOverlayView {
    func setup() {
        addSubview(archivedLabel)
        prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        setDefaultTexts()
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += [archivedLabel.centerXAnchor.constraint(equalTo: centerXAnchor)]
        c += [archivedLabel.centerYAnchor.constraint(equalTo: centerYAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.x64112BBold27TextStyle().apply(to: archivedLabel)
        backgroundColor = .pst_xC0C0C0a85
    }
    
    func setDefaultTexts() {
        archivedLabel.text = LocalizedStrings.archived
    }
}
