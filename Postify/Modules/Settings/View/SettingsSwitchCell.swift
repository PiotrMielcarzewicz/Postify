//
//  SettingsSwitchCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 12/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import UIKit
import Visually

class SettingsSwitchCell: UITableViewCell, Reusable {
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    private var onToggle: ((Bool) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with option: SettingsOption, isOn: Bool, onToggle: @escaping (Bool) -> ()) {
        self.onToggle = nil
        toggle.setOn(isOn, animated: false)
        self.onToggle = onToggle
        titleLabel.text = option.title
        icon.image = option.icon
    }
}

private extension SettingsSwitchCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        addConstraints()
        applyStyling()
        configureTarget()
    }
    
    func addSubviews() {
        contentView.addSubviews(icon,
                                toggle,
                                titleLabel)
    }
    
    func addConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-titleLabel-|)
        c += [icon.heightAnchor.constraint(equalToConstant: 28)]
        c += [icon.widthAnchor.constraint(equalToConstant: 28)]
        c += [icon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
              toggle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)]
        c += H(|-16-icon-16-titleLabel-16-toggle-16-|)
        NSLayoutConstraint.activate(c)
    }
    
    func applyStyling() {
        Styles.blackRegular17TextStyle().apply(to: titleLabel)
        icon.contentMode = .center
    }
    
    func configureTarget() {
        toggle.addTarget(self,
                         action: #selector(didSwitchToggle(_:)),
                         for: .valueChanged)
    }
    
    @objc func didSwitchToggle(_ toggle: UISwitch) {
        onToggle?(toggle.isOn)
    }
}
