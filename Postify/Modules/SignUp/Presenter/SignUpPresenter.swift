//
//  SignUpPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 08/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol SignUpPresenter {
    func viewDidLoad()
    func handleCreateButtonTapped(with form: UserForm)
}

class SignUpPresenterImp: SignUpPresenter {
    private unowned let view: SignUpView
    private let interactor: SignUpInteractor
    private let validator: Validator
    
    init(view: SignUpView,
         interactor: SignUpInteractor,
         validator: Validator) {
        self.view = view
        self.interactor = interactor
        self.validator = validator
    }
    
    func viewDidLoad() {
        let titleViewModel = TitleCellViewModel(title: LocalizedStrings.createAccount,
                                                subtitle: LocalizedStrings.createAccountDescription + "\n",
                                                titleSize: .normal)
        let elements: [SignUpStackElement] = [.title(titleViewModel),
                                              .form]
        view.hydrate(with: elements)
    }
    
    func handleCreateButtonTapped(with form: UserForm) {
        guard isValid(form) else { return }
        
        view.showLoadingHUD()
        interactor.signUp(with: form) { [weak self] result in
            self?.view.hideLoadingHUD()
            switch result {
            case .success:
                self?.view.showAlert(.accountCreated)
            case let .failure(error):
                self?.view.showAlert(for: error)
            }
        }
    }
}

private extension SignUpPresenterImp {
    func isValid(_ form: UserForm) -> Bool {
        guard validator.validateNonEmpty(form.email),
              validator.validateNonEmpty(form.password),
              validator.validateNonEmpty(form.repeatPassword),
              validator.validateNonEmpty(form.firstName),
              validator.validateNonEmpty(form.lastName),
              validator.validateNonEmpty(form.city),
              validator.validateNonEmpty(form.country),
              validator.validateNonEmpty(form.phoneNumber) else { view.showAlert(.emptyFields); return false }
        
        guard form.password == form.repeatPassword else { view.showAlert(.mismatchedPasswords); return false }
        guard validator.validate(form.phoneNumber, type: .phoneNumber) else { view.showAlert(.invalidPhoneNumber); return false }
        
        return true
    }
}
