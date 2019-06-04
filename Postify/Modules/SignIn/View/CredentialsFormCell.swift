//
//  CredentialsFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

protocol CredentialsProvider: class {
    func getEnteredCredentials() -> Credentials
}

class CredentialsFormCell: UITableViewCell, Reusable {
    private let emailTextField = UITextField()
    private let emailIcon = UIImageView()
    private let emailSeparator = Separator()
    private let passwordTextField = UITextField()
    private let passwordIcon = UIImageView()
    private let passwordSeparator = Separator()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CredentialsFormCell: CredentialsProvider {
    func getEnteredCredentials() -> Credentials {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        return Credentials(email: email,
                           password: password)
    }
}

private extension CredentialsFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        configureIcons()
        applyStyling()
        setTexts()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(emailTextField,
                                emailIcon,
                                emailSeparator,
                                passwordTextField,
                                passwordIcon,
                                passwordSeparator)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-60-emailTextField[40]-emailSeparator[1]-24-passwordTextField[40]-passwordSeparator[1]-|)
        c += H(|-48-emailIcon[28]-16-emailTextField-48-|)
        c += H(|-48-emailSeparator-48-|)
        c += H(|-48-passwordIcon[28]-16-passwordTextField-48-|)
        c += H(|-48-passwordSeparator-48-|)
        c += H(emailIcon[28])
        c += H(passwordIcon[28])
        c += [emailIcon.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
              passwordIcon.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor)]
        NSLayoutConstraint.activate(c)
    }
    
    func configureIcons() {
        emailIcon.image = #imageLiteral(resourceName: "ic_email_white")
        passwordIcon.image = #imageLiteral(resourceName: "ic_password_white")
        emailIcon.contentMode = .scaleAspectFit
        passwordIcon.contentMode = .scaleAspectFit
    }
    
    func applyStyling() {
        [emailTextField, passwordTextField].forEach {
            Styles.whiteRegular17TextStyle().apply(to: $0)
            $0.autocapitalizationType = .none
        }
        
        [emailSeparator,
         passwordSeparator].forEach { $0.color = .white }
        
        passwordTextField.isSecureTextEntry = true
        backgroundColor = .clear
        
        #if DEBUG
            emailTextField.text = "piotr.mielcarzewicz1@gmail.com"
            passwordTextField.text = "qwerty123"
        #endif
    }
    
    func setTexts() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: LocalizedStrings.email,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedStrings.password,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
}
