//
//  SignInActionsCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Reusable
import Visually
import UIKit

protocol SignInActionsDelegate: class {
    func actionSelected(_ action: SignInAction)
}

enum SignInAction {
    case signIn
    case forgotPassword
    case signUp
}

class SignInActionsCell: UITableViewCell, Reusable {
    private let signInButton = UIButton(type: .system)
    private let forgotPasswordButton = UIButton(type: .system)
    private let orView = OrLabelView()
    private let signUpButton = UIButton(type: .system)
    private weak var delegate: SignInActionsDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with delegate: SignInActionsDelegate) {
        self.delegate = delegate
    }
}

private extension SignInActionsCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        setTexts()
        applyStyling()
        addTargets()
        selectionStyle = .none
    }
    
    func addSubviews() {
        contentView.addSubviews(signInButton,
                                forgotPasswordButton,
                                orView,
                                signUpButton)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += V(|-60-signInButton[55]-24-forgotPasswordButton-6-orView-6-signUpButton-|)
        c += H(|-48-signInButton-48-|)
        c += H(|-24-forgotPasswordButton-24-|)
        c += H(|-64-orView-64-|)
        c += H(|-24-signUpButton-24-|)
        NSLayoutConstraint.activate(c)
    }
    
    func setTexts() {
        signInButton.setTitle(LocalizedStrings.login, for: .normal)
        forgotPasswordButton.setTitle(LocalizedStrings.forgotPassword, for: .normal)
        signUpButton.setTitle(LocalizedStrings.dontHaveAccount, for: .normal)
    }
    
    func applyStyling() {
        Styles.themeSemibold36RoundedCorner10ButtonStyle().apply(to: signInButton)
        signInButton.setTitleColor(.pst_x64112B, for: .normal)
        [forgotPasswordButton,
         signUpButton].forEach { Styles.whiteRegular17TextStyle().apply(to: $0) }
        backgroundColor = .clear
    }
    
    func addTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    @objc func didTapSignIn() {
        delegate?.actionSelected(.signIn)
    }
    
    @objc func didTapSignUp() {
        delegate?.actionSelected(.signUp)
    }
    
    @objc func didTapForgotPassword() {
        delegate?.actionSelected(.forgotPassword)
    }
}
