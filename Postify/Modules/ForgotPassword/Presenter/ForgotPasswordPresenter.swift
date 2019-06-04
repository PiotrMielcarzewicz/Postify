//
//  ForgotPasswordPresenter.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 04/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

protocol ForgotPasswordPresenter {
    func viewDidLoad()
    func userDidTapSend(with email: String)
    func userDidTapClose()
}

class ForgotPasswordPresenterImp: ForgotPasswordPresenter {
    private unowned let view: ForgotPaswordView
    private let interactor: ForgotPasswordInteractor
    private let router: DismissableRouter?
    private let validator: Validator
    private let shouldShowCloseButton: Bool
    
    init(view: ForgotPaswordView,
         interactor: ForgotPasswordInteractor,
         router: DismissableRouter?,
         validator: Validator,
         shouldShowCloseButton: Bool) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.validator = validator
        self.shouldShowCloseButton = shouldShowCloseButton
    }
    
    func viewDidLoad() {
        let title: String = {
            if shouldShowCloseButton {
                return LocalizedStrings.passwordResetQuestion
            } else {
                return LocalizedStrings.forgotPasswordTitle
            }
        }()
        let titleViewModel = TitleCellViewModel(title: title,
                                                subtitle: LocalizedStrings.forgotPasswordDescription,
                                                titleSize: .normal)
        let elements: [ForgotPasswordStackElement] = [.title(titleViewModel),
                                                      .emailField,
                                                      .sendButton]
        view.hydrate(with: elements)
        if shouldShowCloseButton {
            view.showCloseButton()
        }
    }
    
    func userDidTapSend(with email: String) {
        guard validator.validateNonEmpty(email) else {
            view.showAlert(.emptyFields)
            return
        }
        
        view.showLoadingHUD()
        interactor.sendResetPasswordEmail(with: email) { [weak self] result in
            self?.view.hideLoadingHUD()
            switch result {
            case .success:
                self?.view.showAlert(.resetEmailSent)
            case let .failure(error):
                self?.view.showAlert(.custom(title: LocalizedStrings.errorCapitalized,
                                             subtitle: error.localizedDescription,
                                             style: .danger))
            }
        }
    }
    
    func userDidTapClose() {
        router?.dismiss()
    }
}
