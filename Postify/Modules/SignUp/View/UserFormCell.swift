//
//  UserFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol UserFormDelegate: class {
    func getUserForm() -> UserForm
}

class UserFormCell: UITableViewCell, Reusable {
    private let emailFormField = UserFormFieldView()
    private let passwordFormField = UserFormFieldView()
    private let repeatPasswordFormField = UserFormFieldView()
    private let firstnameFormField = UserFormFieldView()
    private let lastnameFormField = UserFormFieldView()
    private let countryFormField = UserFormFieldView()
    private let cityFormField = UserFormFieldView()
    private let phoneFormField = UserFormFieldView()
    private lazy var stackView = UIStackView(arrangedSubviews: [emailFormField,
                                                                passwordFormField,
                                                                repeatPasswordFormField,
                                                                firstnameFormField,
                                                                lastnameFormField,
                                                                countryFormField,
                                                                cityFormField,
                                                                phoneFormField])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hydrate(with form: UserForm? = nil) {
        emailFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.email,
                                                        text: form?.email,
                                                        placeholder: LocalizedStrings.typeEmail))
        passwordFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.password,
                                                        text: form?.password,
                                                        placeholder: LocalizedStrings.typePassword,
                                                        type: .secure))
        repeatPasswordFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.repeatPassword,
                                                        text: form?.repeatPassword,
                                                        placeholder: LocalizedStrings.typePassword,
                                                        type: .secure))
        firstnameFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.firstname,
                                                            text: form?.firstName,
                                                            placeholder: LocalizedStrings.typeFirstname))
        lastnameFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.lastname,
                                                           text: form?.lastName,
                                                           placeholder: LocalizedStrings.typeLastname))
        countryFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.country,
                                                          text: form?.country,
                                                          placeholder: LocalizedStrings.typeCountry))
        cityFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.city,
                                                       text: form?.city,
                                                       placeholder: LocalizedStrings.typeCity))
        phoneFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.phoneNumber,
                                                        text: form?.phoneNumber,
                                                        placeholder: LocalizedStrings.typePhoneNumber,
                                                        type: .numberPad))
        
    }
}

extension UserFormCell: UserFormDelegate {
    func getUserForm() -> UserForm {
        return UserForm(email: emailFormField.getText(),
                        password: passwordFormField.getText(),
                        repeatPassword: repeatPasswordFormField.getText(),
                        firstName: firstnameFormField.getText(),
                        lastName: lastnameFormField.getText(),
                        phoneNumber: phoneFormField.getText(),
                        city: cityFormField.getText(),
                        country: countryFormField.getText())
    }
}

private extension UserFormCell {
    func setup() {
        addSubviews()
        contentView.prepareSubviewsForAutolayout()
        setupConstraints()
        setupStackView()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func addSubviews() {
        contentView.addSubviews(stackView)
    }
    
    func setupConstraints() {
        var c: [NSLayoutConstraint] = []
        c += H(|-stackView-|)
        c += V(|-stackView-|)
        NSLayoutConstraint.activate(c)
    }
    
    func setupStackView() {
        stackView.spacing = 0
        stackView.axis = .vertical
    }
}
