//
//  ActionButtonCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import Reusable
import UIKit

class ActionButtonCell: UITableViewCell, Reusable {
    private let actionButton = UIButton(type: .system)
    private var actionHandler: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(actionHandler: @escaping () -> ()) {
        self.actionHandler = actionHandler
    }
}

private extension ActionButtonCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        setText()
        applyStyling()
        addTarget()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(actionButton)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-actionButton[55]-|)
        c += H(|-48-actionButton-48-|)
        NSLayoutConstraint.activate(c)
    }
    
    func setText() {
        actionButton.setTitle(LocalizedStrings.send, for: .normal)
    }
    
    func applyStyling() {
        Styles.themeSemibold36RoundedCorner10ButtonStyle().apply(to: actionButton)
        actionButton.setTitleColor(.pst_x64112B, for: .normal)
        backgroundColor = .clear
    }
    
    func addTarget() {
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        actionHandler?()
    }
}
