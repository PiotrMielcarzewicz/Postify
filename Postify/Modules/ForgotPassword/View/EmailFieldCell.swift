//
//  EmailFieldCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

protocol EmailProvider: class {
    func getEnteredEmail() -> String
}

class EmailFieldCell: UITableViewCell, Reusable {
    private let emailTextField = UITextField()
    private let emailIcon = UIImageView()
    private let emailSeparator = Separator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmailFieldCell: EmailProvider {
    func getEnteredEmail() -> String {
        return emailTextField.text ?? ""
    }
}

private extension EmailFieldCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        configureIcon()
        applyStyling()
        setText()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(emailTextField,
                                emailIcon,
                                emailSeparator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-80-emailTextField[40]-emailSeparator[1]-32-|)
        c += H(|-48-emailIcon[28]-16-emailTextField-48-|)
        c += H(|-48-emailSeparator-48-|)
        c += H(emailIcon[28])
        c += [emailIcon.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    func configureIcon() {
        emailIcon.image = #imageLiteral(resourceName: "ic_email_white")
        emailIcon.contentMode = .scaleAspectFit
    }
    
    func applyStyling() {
        Styles.whiteRegular17TextStyle().apply(to: emailTextField)
        emailTextField.autocapitalizationType = .none
        emailSeparator.color = .white
        backgroundColor = .clear
    }
    
    func setText() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: LocalizedStrings.email,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
}
