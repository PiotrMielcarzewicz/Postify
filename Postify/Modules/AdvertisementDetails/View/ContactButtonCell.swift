//
//  ContactButtonCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 14/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import Visually

class ContactButtonCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let button = UIButton(type: .system)
    private var tapTarget: ContactButtonViewModel.Target!
    private var onTap: ((ContactButtonViewModel.Target) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with viewModel: ContactButtonViewModel, onTap: @escaping (ContactButtonViewModel.Target) -> ()) {
        self.onTap = onTap
        tapTarget = viewModel.target
        titleLabel.text = viewModel.title
        button.setTitle(viewModel.buttonText, for: .normal)
        button.underline()
    }
}

private extension ContactButtonCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        applyStyling()
        configureTarget()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(titleLabel,
                                button)
    }
    
    func setupConstraints() {
        button.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        var c: [NSLayoutConstraint] = []
        c += H(|-16-titleLabel-8-button-16-|)
        c += V(|-16-titleLabel-|)
        c += [button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.lightGrayRegular17TextStyle().apply(to: titleLabel)
        Styles.regular17TextStyle().apply(to: button)
    }
    
    func configureTarget() {
        button.addTarget(self,
                         action: #selector(didTapButton),
                         for: .touchUpInside)
    }
    
    @objc func didTapButton() {
        onTap?(tapTarget)
    }
}
