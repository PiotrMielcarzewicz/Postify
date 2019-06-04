//
//  MyProfileFormCell.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import Visually
import UIKit
import Reusable

protocol MyProfileFormDelegate: class {
    func getUser() -> User
}

class MyProfileFormCell: UITableViewCell, Reusable {
    var user: User!
    private let emailFormField = MyProfileFormFieldView()
    private let firstnameFormField = MyProfileFormFieldView()
    private let lastnameFormField = MyProfileFormFieldView()
    private let countryFormField = MyProfileFormFieldView()
    private let cityFormField = MyProfileFormFieldView()
    private let phoneFormField = MyProfileFormFieldView()
    private lazy var stackView = UIStackView(arrangedSubviews: [emailFormField,
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
    
    func hydrate(with user: User) {
        self.user = user
        emailFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.email,
                                                        text: user.email,
                                                        placeholder: LocalizedStrings.typeEmail,
                                                        type: .locked))
        firstnameFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.firstname,
                                                            text: user.firstName,
                                                            placeholder: LocalizedStrings.typeFirstname))
        lastnameFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.lastname,
                                                           text: user.lastName,
                                                           placeholder: LocalizedStrings.typeLastname))
        countryFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.country,
                                                          text: user.country,
                                                          placeholder: LocalizedStrings.typeCountry))
        cityFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.city,
                                                       text: user.city,
                                                       placeholder: LocalizedStrings.typeCity))
        phoneFormField.hydrate(with: FormFieldViewModel(title: LocalizedStrings.phoneNumber,
                                                        text: user.phoneNumber,
                                                        placeholder: LocalizedStrings.typePhoneNumber,
                                                        type: .numberPad))
        
    }
}

extension MyProfileFormCell: MyProfileFormDelegate {
    func getUser() -> User {
        return User(id: user.id,
                    email: emailFormField.getText(),
                    firstName: firstnameFormField.getText(),
                    lastName: lastnameFormField.getText(),
                    phoneNumber: phoneFormField.getText(),
                    city: cityFormField.getText(),
                    country: countryFormField.getText(),
                    publicPhoneNumber: user.publicPhoneNumber)
    }
}

private extension MyProfileFormCell {
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
